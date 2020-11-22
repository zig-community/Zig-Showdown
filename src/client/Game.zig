const std = @import("std");
const zwl = @import("zwl");
const build_options = @import("build_options");
const transitions = @import("transitions.zig");
const draw = @import("pixel_draw");

const Self = @This();
const Resources = @import("Resources.zig");
const WindowPlatform = @import("root").WindowPlatform;

///! The core management structure for the game. This is
///! mostly platform independent game logic and rendering implementation.
const states = struct {
    pub const CreateServer = @import("states/CreateServer.zig");
    pub const CreateSpGame = @import("states/CreateSpGame.zig");
    pub const Credits = @import("states/Credits.zig");
    pub const Gameplay = @import("states/Gameplay.zig");
    pub const JoinGame = @import("states/JoinGame.zig");
    pub const MainMenu = @import("states/MainMenu.zig");
    pub const Options = @import("states/Options.zig");
    pub const PauseMenu = @import("states/PauseMenu.zig");
    pub const Splash = @import("states/Splash.zig");
};

const State = build_options.State;
//  enum {
//     create_server,
//     create_sp_game,
//     credits,
//     gameplay,
//     join_game,
//     main_menu,
//     options,
//     pause_menu,
//     splash,
// };

const StateTransition = struct {
    from: State,
    to: State,
    progress: f32,
    style: transitions.Style,
    duration: f32,
};

const StateAndTransition = union(enum) {
    state: State,
    transition: StateTransition,
};

allocator: *std.mem.Allocator,
resources: *Resources,

create_server: states.CreateServer,
create_sp_game: states.CreateSpGame,
credits: states.Credits,
gameplay: states.Gameplay,
join_game: states.JoinGame,
main_menu: states.MainMenu,
options: states.Options,
pause_menu: states.PauseMenu,
splash: states.Splash,

current_state: StateAndTransition = .{
    .state = build_options.initial_state,
},
next_state: ?State = null,

transition_buffer_from: []u32,
transition_buffer_to: []u32,

/// total time spent in updating
update_time: f32 = 0.0,

/// total time spent in drawing
render_time: f32 = 0.0,

// used resources:
font_id: Resources.TexturePool.ResourceName,

pub fn init(allocator: *std.mem.Allocator, resources: *Resources) !Self {
    var game = Self{
        .allocator = allocator,
        .resources = resources,

        .create_server = .{},
        .create_sp_game = .{},
        .credits = .{},
        .gameplay = undefined,
        .join_game = .{},
        .main_menu = undefined,
        .options = .{},
        .pause_menu = .{},
        .splash = states.Splash.init(),

        .transition_buffer_from = undefined,
        .transition_buffer_to = undefined,

        .font_id = try resources.textures.getName("/assets/font.tex"),
    };

    game.main_menu = try states.MainMenu.init(resources);

    game.gameplay = try states.Gameplay.init(allocator, resources);
    errdefer game.gameplay.deinit();

    game.transition_buffer_from = try allocator.alloc(u32, 1280 * 720);
    errdefer allocator.free(game.transition_buffer_from);

    game.transition_buffer_to = try allocator.alloc(u32, 1280 * 720);
    errdefer allocator.free(game.transition_buffer_to);

    // this is necessary to make a clean enter/exit semantic.
    // every other leave/enter pair will be done in update,
    // the final leave will be called in deinit()
    try game.callOnState(game.current_state.state, "enter", .{0.0});

    return game;
}

pub fn deinit(self: *Self) void {
    switch (self.current_state) {
        .state => |state| self.callOnState(state, "leave", .{self.update_time}) catch unreachable,

        // if we are currently in a transition, leave the state we transition to
        .transition => |t| self.callOnState(t.to, "leave", .{self.update_time}) catch unreachable,
    }

    self.gameplay.deinit();
    self.allocator.free(self.transition_buffer_from);
    self.allocator.free(self.transition_buffer_to);
    self.* = undefined;
}

fn callOnState(self: *Self, state: State, comptime fun: []const u8, args: anytype) !void {
    const H = struct {
        fn maybeCall(ptr: anytype, inner_args: anytype) !void {
            const F = @TypeOf(ptr.*);
            if (@hasDecl(F, fun)) {
                return @call(.{}, @field(F, fun), .{ptr} ++ inner_args);
            }
        }
    };
    switch (state) {
        .create_server => return H.maybeCall(&self.create_server, args),
        .create_sp_game => return H.maybeCall(&self.create_sp_game, args),
        .credits => return H.maybeCall(&self.credits, args),
        .gameplay => return H.maybeCall(&self.gameplay, args),
        .join_game => return H.maybeCall(&self.join_game, args),
        .main_menu => return H.maybeCall(&self.main_menu, args),
        .options => return H.maybeCall(&self.options, args),
        .pause_menu => return H.maybeCall(&self.pause_menu, args),
        .splash => return H.maybeCall(&self.splash, args),
    }
}

pub fn update(self: *Self, delta_time: f32) !void {
    defer self.update_time += delta_time;

    if (self.next_state != null) {
        std.debug.assert(self.current_state == .state);
        std.debug.assert(self.current_state.state != self.next_state.?);

        // workaround for result location problem
        const current_state = self.current_state.state;

        try self.callOnState(current_state, "leave", .{self.update_time});
        try self.callOnState(self.next_state.?, "enter", .{self.update_time});

        self.current_state = .{
            .transition = .{
                .from = current_state,
                .to = self.next_state.?,
                .progress = 0.0,

                // Implements mapping for state transitions
                .style = switch (current_state) {
                    .splash,
                    .main_menu,
                    => .slice_bl_to_tr,

                    .options,
                    .credits,
                    .create_server,
                    .create_sp_game,
                    .join_game,
                    => @as(transitions.Style, switch (self.next_state.?) {
                        .main_menu => .slice_tr_to_bl,
                        else => .in_and_out,
                    }),

                    else => .in_and_out,
                },
                .duration = 0.25,
            },
        };
        self.next_state = null;
    }

    switch (self.current_state) {
        .state => |state| try self.callOnState(state, "update", .{ self.update_time, delta_time }),
        .transition => {}, // do not update game logic in transitions
    }
}

fn renderState(self: *Self, state: State, target: zwl.PixelBuffer, delta_time: f32) !void {
    switch (state) {
        .create_server => try self.create_server.render(target, self.render_time, delta_time),
        .create_sp_game => try self.create_sp_game.render(target, self.render_time, delta_time),
        .credits => try self.credits.render(target, self.render_time, delta_time),
        .gameplay => try self.gameplay.render(target, self.render_time, delta_time),
        .join_game => try self.join_game.render(target, self.render_time, delta_time),
        .main_menu => try self.main_menu.render(target, self.render_time, delta_time),
        .options => try self.options.render(target, self.render_time, delta_time),
        .pause_menu => try self.pause_menu.render(target, self.render_time, delta_time),
        .splash => try self.splash.render(target, self.render_time, delta_time),
    }
}

pub fn render(self: *Self, target: zwl.PixelBuffer, delta_time: f32) !void {
    defer self.render_time += delta_time;

    switch (self.current_state) {
        .state => |state| try self.callOnState(state, "render", .{ target, self.render_time, delta_time }),
        .transition => |*transition| {
            const src_from = zwl.PixelBuffer{
                .width = 1280,
                .height = 720,
                .data = self.transition_buffer_from.ptr,
            };
            const src_to = zwl.PixelBuffer{
                .width = 1280,
                .height = 720,
                .data = self.transition_buffer_to.ptr,
            };

            try self.callOnState(transition.from, "render", .{ src_from, self.render_time, delta_time });
            try self.callOnState(transition.to, "render", .{ src_to, self.render_time, delta_time });

            transitions.render(src_from, src_to, target, transition.progress, transition.style);

            transition.progress += delta_time / transition.duration;
            if (transition.progress >= 1.0) {
                self.current_state = .{
                    .state = transition.to,
                };
            }
        },
    }

    if (build_options.enable_frame_counter) { // Show frame time counter
        var b = draw.Buffer{
            .width = target.width,
            .height = target.height,
            .screen = std.mem.sliceAsBytes(target.span()),
            .depth = undefined, // doesn't hurt as we're only doing 2D rendering
        };

        const font = draw.BitmapFont{
            .texture = (try self.resources.textures.get(self.font_id, Resources.usage.debug_draw)).toPixelDraw(),
            .font_size_x = 12,
            .font_size_y = 16,
            .character_spacing = 11,
        };

        var print_buff: [128]u8 = undefined;
        const fpst = try std.fmt.bufPrint(
            &print_buff,
            "{d: >6.2} ms / {d: >4.0} FPS",
            .{ 1000.0 * delta_time, 1 / delta_time },
        );
        b.drawBitmapFont(fpst, 20, 20, 1, 1, font);
    }
}

pub fn switchToState(self: *Self, new_state: State) void {
    std.debug.assert(self.current_state == .state);
    std.debug.assert(self.current_state.state != new_state);
    std.debug.assert(self.next_state == null);
    self.next_state = new_state;
}

pub fn fromComponent(component: anytype) *Self {
    comptime var field_name: ?[]const u8 = null;
    inline for (std.meta.fields(Self)) |fld| {
        if (fld.field_type == @TypeOf(component.*)) {
            if (field_name != null)
                @compileError("There are two components of that type declared in Game. Please use @fieldParentPtr directly!");

            field_name = fld.name;
        }
    }
    if (field_name == null)
        @compileError("The game has no matching component of that type.");

    return @fieldParentPtr(Self, field_name.?, component);
}
