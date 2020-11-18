const std = @import("std");
const zwl = @import("zwl");

const transitions = @import("transitions.zig");

//! This file implements the core game structure and state transitions.

pub const WindowPlatform = @import("root").WindowPlatform;

const states = struct {
    pub const CreateServer = @import("states/create_server.zig");
    pub const CreateSpGame = @import("states/create_sp_game.zig");
    pub const Credits = @import("states/credits.zig");
    pub const Gameplay = @import("states/gameplay.zig");
    pub const JoinGame = @import("states/join_game.zig");
    pub const MainMenu = @import("states/main_menu.zig");
    pub const Options = @import("states/options.zig");
    pub const PauseMenu = @import("states/pause_menu.zig");
    pub const Splash = @import("states/splash.zig");
};

/// The core management structure for the game. This is
/// mostly platform independent game logic and rendering implementation.
pub const Game = struct {
    const Self = @This();

    const State = enum {
        create_server,
        create_sp_game,
        credits,
        gameplay,
        join_game,
        main_menu,
        options,
        pause_menu,
        splash,
    };

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

    create_server: states.CreateServer,
    create_sp_game: states.CreateSpGame,
    credits: states.Credits,
    gameplay: states.Gameplay,
    join_game: states.JoinGame,
    main_menu: states.MainMenu,
    options: states.Options,
    pause_menu: states.PauseMenu,
    splash: states.Splash,

    current_state: StateAndTransition = .{ .state = .splash },

    transition_buffer_from: []u32,
    transition_buffer_to: []u32,

    /// total time spent in updating
    update_time: f32 = 0.0,

    /// total time spent in drawing
    render_time: f32 = 0.0,

    pub fn init(allocator: *std.mem.Allocator) !Self {
        var game = Self{
            .allocator = allocator,

            .create_server = .{},
            .create_sp_game = .{},
            .credits = .{},
            .gameplay = .{},
            .join_game = .{},
            .main_menu = .{},
            .options = .{},
            .pause_menu = .{},
            .splash = .{},

            .transition_buffer_from = undefined,
            .transition_buffer_to = undefined,
        };

        game.transition_buffer_from = try allocator.alloc(u32, 1280 * 720);
        errdefer allocator.free(game.transition_buffer_from);

        game.transition_buffer_to = try allocator.alloc(u32, 1280 * 720);
        errdefer allocator.free(game.transition_buffer_to);

        game.current_state = .{
            .transition = .{
                .from = .splash,
                .to = .main_menu,
                .progress = 0.0,
                .style = .slice_bl_to_tr,
                .duration = 0.25,
            },
        };

        return game;
    }

    pub fn deinit(self: *Self) void {
        self.allocator.free(self.transition_buffer_from);
        self.allocator.free(self.transition_buffer_to);
        self.* = undefined;
    }

    pub fn update(self: *Self, delta_time: f32) !void {
        defer self.update_time += delta_time;
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
            .state => |state| try self.renderState(state, target, delta_time),
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

                try self.renderState(transition.from, src_from, delta_time);
                try self.renderState(transition.to, src_to, delta_time);

                transitions.render(src_from, src_to, target, transition.progress, transition.style);

                transition.progress += delta_time / transition.duration;
                if (transition.progress >= 1.0) {
                    self.current_state = .{
                        .state = transition.to,
                    };
                }
            },
        }
    }
};
