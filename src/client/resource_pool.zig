const std = @import("std");

const log = std.log.scoped(.resources);

//! This implements a resource management system that has a garbage collection
//! model and can be used for easy loading/unloading of resources.
//!
//! First of all, this system uses a translation from strings to resource names (integer ids).
//! This translation should happen only once and after that resource names should be used.
//! Resources will always be addressed with these IDs.
//!
//! A resource then has the following lifetime:
//! - Loaded from disk and created with the first call to `.get()` or `.preload()`
//! - Held in memory via usage bits. Each bit has a used-defined meaning.
//! - Each call to `.get` will set the provided usage bits
//! - Usage bits are cleared with `.releaseResources()`
//! - When `.collectGarbage()` is called and a resource has currently no usage bits set, the resource is freed.
//!
//! This design allows the system to share resources between modules that have no idea of the existence of other modules
//! except for the definition of usage bits. Each module calls `.get()` and `.releaseResources()` to its liking and after that
//! it calls `.collectGarbage()`.
//! If resources are shared between modules, only the non-shared resources will be released.
//! Example:
//! - A module *HUD* loads a resource `font.tga` to display player health
//! - A module *Level* loads a resource `font.tga` to display in-level counters.
//! - The same *Level* module loads a resource `player.fbx` to provide a 3D model for the player
//! - When the module *Level* is unloaded, it will release all resources with its own usage bits.
//! This means that `player.fbx` will be unloaded from memory, but `font.tga` will remain.
//!
//! `.collectGarbage()` can also be called in a main loop without hurt. This will then enforce that
//! released resources are actually destroyed.
//!
//! Note: It can be useful to `.releaseResources()` from a previous set, then `.get` all the freshly required
//! resources and only then call `.collectGarbage()`. This allows sharing usage bits between two "memory sessions".
//!
//! TODO:
//! - Figure out if resource handles can be translated at comptime
//!   - This means no runtime resource loading
//!   - Would allow really fast lookups of resources (no string translation required)
//!   - Make this the mode that is used in release modes (@embedFile the resources, don't use fs, make getName not fail at all)

const resource_data = @import("showdown-resources");

pub const Error = error{ OutOfMemory, InvalidData };

/// Usage mask type that is used to mark usage of resources.
/// Each bit represents a certain usage type
pub const Mask = u64;

pub const BufferView = MappingOfFile.View;

/// When `true`, does not require a directory handle.
pub const uses_embedded_data = resource_data.embedded;

/// A resource manager for a given type.
/// Resources are obtained via a resource name (string identifier)
/// and will be alive until no one referenced them anymore.
/// Resources will be freed afterwards when necessary.
pub fn ResourcePool(
    comptime T: type,
    comptime Context: type,
    loadFn: fn (ctx: Context, allocator: *std.mem.Allocator, buffer: BufferView, extension_hint: []const u8) Error!T,
    freeFn: fn (ctx: Context, allocator: *std.mem.Allocator, self: *T) void,
) type {
    return struct {
        const Self = @This();

        /// The resource type that is managed
        pub const Resource = T;

        /// A unique handle that represents a resource in the system.
        /// Resource names are only unique in regard to a ResourceManager though.
        pub const ResourceName = enum(u32) { _ }; // u32 should be enough resources for everyone

        /// A resource that is managed by this structure.
        const ManagedResource = struct {
            usage: Mask,
            resource: Resource,
            file_mapping: MappingOfFile,
        };
        const ManagedResourceMap = std.ArrayHashMapUnmanaged(
            ResourceName,
            ManagedResource,
            hashName,
            eqlName,
            false,
        );

        fn hashName(m: ResourceName) u32 {
            return @enumToInt(m);
        }

        fn eqlName(a: ResourceName, b: ResourceName) bool {
            return a == b;
        }

        const ResourceRoot = if (resource_data.embedded) void else std.fs.Dir;

        allocator: *std.mem.Allocator,
        context: Context,

        /// Arena allocator that stores strings used in the resource manager
        string_arena: std.heap.ArenaAllocator,

        /// A map from the user-defined resource name to internal *fast* resource names (indices)
        resource_names: std.StringHashMapUnmanaged(ResourceName),

        /// The next resource name to be allocated. This needs to increment for every item added to
        /// resource_names.
        next_resource_name: u32 = 0,

        resources: ManagedResourceMap,

        root_directory: ResourceRoot,

        /// `allocator` and `root_directory` must valid until a call to deinit()
        pub fn init(allocator: *std.mem.Allocator, root_directory: ResourceRoot, context: Context) Self {
            return Self{
                .allocator = allocator,
                .context = context,
                .root_directory = root_directory,
                .string_arena = std.heap.ArenaAllocator.init(allocator),
                .resource_names = std.StringHashMapUnmanaged(ResourceName){},
                .resources = ManagedResourceMap{},
            };
        }

        pub fn deinit(self: *Self) void {
            for (self.resources.items()) |*item| {
                freeFn(self.context, self.allocator, &item.value.resource);
                item.value.file_mapping.deinit();
            }

            self.resource_names.deinit(self.allocator);
            self.resources.deinit(self.allocator);
            self.string_arena.deinit();
            self.* = undefined;
        }

        /// Returns a resource name (handle) to the given path.
        /// For the same path, the same name will be returned.
        pub fn getName(self: *Self, resource_path: []const u8) !ResourceName {
            std.debug.assert(std.fs.path.isAbsolutePosix(resource_path));

            const gopr = try self.resource_names.getOrPut(self.allocator, resource_path);
            if (!gopr.found_existing) {
                // next statement is going to replace the user-passed path
                // which was stored by the hash map with an actual self-owned
                // string pointer.
                errdefer _ = self.resource_names.remove(resource_path);
                gopr.entry.key = try self.string_arena.allocator.dupe(u8, resource_path);

                gopr.entry.value = @intToEnum(ResourceName, self.next_resource_name);
                self.next_resource_name += 1;
            }

            return gopr.entry.value;
        }

        /// Collects garbage and frees all resources that are currently not referenced.
        /// This means that they have no `usage` bits set.
        pub fn collectGarbage(self: *Self) void {
            const items = self.resources.items();
            var len = items.len;
            var i: usize = 0;
            while (i < len) {
                if (items[i].value.usage == 0) {
                    // delete all unused resources
                    var old_entry = self.resources.remove(items[i].key) orelse unreachable;
                    freeFn(self.context, self.allocator, &old_entry.value.resource);
                    old_entry.value.file_mapping.deinit();
                    len -= 1; // swapRemove keeps the next item at `i`, but reduces length
                } else {
                    // keep iterating
                    i += 1;
                }
            }
        }

        /// Will reset all bits in `usage` for all resources.
        /// This allows freeing all resources that only have the `usage` bits set to be cleaned up
        /// in the next garbage collection cycle.
        pub fn releaseResources(self: *Self, usage: Mask) void {
            for (self.resources.items()) |*item| {
                item.value.usage &= ~usage;
            }
        }

        /// Obtains access to a resource. The resource will be loaded ad-hoc if not present
        /// already.
        /// The resource will also be marked with all bits in `usage` so it will prevent the
        /// next garbage collection cycle.
        pub fn get(self: *Self, name: ResourceName, usage: Mask) !T {
            const gopr = try self.resources.getOrPut(self.allocator, name);
            if (!gopr.found_existing) {
                errdefer _ = self.resources.remove(name);

                var iter = self.resource_names.iterator();
                const file_name = while (iter.next()) |kv| {
                    if (kv.value == name)
                        break kv.key;
                } else @panic("get received an invalid name from the programmer. This is a bug!");

                // TODO: Change directory handle to the path of the exe, not the CWD
                var file_map = MappingOfFile.init(self.allocator, self.root_directory, file_name) catch |err| switch (err) {
                    error.FileNotFound => {
                        log.emerg("Could not find resource file '{}'", .{file_name});
                        return error.FileNotFound;
                    },
                    else => |e| return e,
                };
                errdefer file_map.deinit();

                gopr.entry.value = ManagedResource{
                    .file_mapping = file_map,
                    .usage = 0,
                    .resource = try loadFn(
                        self.context,
                        self.allocator,
                        file_map.data,
                        filePathExtension(file_name),
                    ),
                };
            }
            gopr.entry.value.usage |= usage; // set the new usage bits
            return gopr.entry.value.resource;
        }

        /// Tries to preload all resources that are available and have the
        /// same path prefix as `prefix`.
        /// This allows a quick loading without knowing all resources names.
        /// `prefix` must be a valid resource identifier!
        pub fn preload(self: *Self, prefix: []const u8, usage: Mask) !void {
            std.debug.assert(std.fs.path.isAbsolutePosix(prefix));
            @panic("TODO: Not implemented yet");
        }
    };
}

fn filePathExtension(path: []const u8) []const u8 {
    const filename = std.fs.path.basename(path);
    return if (std.mem.lastIndexOf(u8, filename, ".")) |index|
        if (index == 0 or index == filename.len - 1)
            ""
        else
            filename[index..]
    else
        "";
}

/// Provides features to map a file into memory quickly
const MappingOfFile = if (std.builtin.endian == .Big)
    platform_impls.Fake // we need to be able to change the data on big endian platforms
else if (resource_data.embedded)
    platform_impls.Embedded
else switch (std.builtin.os.tag) {
    .linux, .macos, .openbsd, .freebsd => platform_impls.Unix,
    .windows => platform_impls.Fake, // TODO: replace with .Windows
    else => @compileError("No implementation for MappingOfFile for this OS!"),
};

const platform_impls = struct {
    /// This is a platform-independent implementation of a "file mapping" where the file is embedded
    /// into the executable itself and is not present on disk.
    const Embedded = struct {
        const Self = @This();
        pub const View = []align(64) const u8;

        data: View,

        pub fn init(allocator: *std.mem.Allocator, dir: std.fs.Dir, path: []const u8) !Self {
            inline for (std.meta.fields(@TypeOf(resource_data.files))) |fld| {
                if (std.mem.eql(u8, fld.name, path))
                    return Self{ .data = @field(resource_data.files, fld.name) };
            }
            return error.FileNotFound;
        }

        pub fn deinit(self: *Self) void {
            self.* = undefined;
        }
    };

    /// This implements the file mapping for windows.
    const Windows = struct {
        const Self = @This();
        pub const View = []const u8;
    };

    /// This implements the file mapping for unix systems using mmap.
    const Unix = struct {
        const Self = @This();
        pub const View = []align(std.mem.page_size) const u8;

        allocator: *std.mem.Allocator,
        data: View,

        pub fn init(allocator: *std.mem.Allocator, dir: std.fs.Dir, path: []const u8) !Self {
            std.debug.assert(path.len > 1 and path[0] == '/');

            var file = try dir.openFile(path[1..], .{
                .intended_io_mode = .blocking,
                .read = true,
                .write = false,
            });
            defer file.close();

            const file_len = try std.math.cast(usize, try file.getEndPos());
            const mapped_mem = try std.os.mmap(
                null,
                file_len,
                std.os.PROT_READ,
                std.os.MAP_SHARED,
                file.handle,
                0,
            );
            errdefer std.os.munmap(mapped_mem);

            return Self{
                .allocator = allocator,
                .data = mapped_mem,
            };
        }

        pub fn deinit(self: *Self) void {
            errdefer std.os.munmap(self.data);
            self.* = undefined;
        }
    };

    /// This is actually the classic way of providing a file view:
    /// Load the file via read() into memory and keep it there.
    const Fake = struct {
        const Self = @This();
        pub const View = []align(64) u8;

        allocator: *std.mem.Allocator,
        data: View,

        pub fn init(allocator: *std.mem.Allocator, dir: std.fs.Dir, path: []const u8) !Self {
            std.debug.assert(path.len > 1 and path[0] == '/');
            const buffer = try dir.readFileAllocOptions(
                allocator,
                path[1..],
                100 * 1024 * 1024, // 100MB per resource should be enough *for now*
                null,
                std.meta.alignment(View), // large alignment,
                null,
            );
            errdefer self.allocator.free(buffer);

            return Self{
                .allocator = allocator,
                .data = buffer,
            };
        }

        pub fn deinit(self: *Self) void {
            self.allocator.free(self.data);
            self.* = undefined;
        }
    };
};

test "ResourceManager" {
    const R = struct {
        const Self = @This();

        var leak_counter: usize = 0;

        pub fn load(ctx: void, allocator: *std.mem.Allocator, data: []const u8, ext: []const u8) Error!Self {
            leak_counter += 1;
            return Self{};
        }

        pub fn deinit(ctx: void, allocator: *std.mem.Allocator, self: *Self) void {
            self.* = undefined;
            leak_counter -= 1;
        }
    };

    {
        var manager = ResourcePool(R, void, R.load, R.deinit).init(std.testing.allocator, std.fs.cwd(), {});
        defer manager.deinit();

        var n0_1 = try manager.getName("/foo/bar/bam");
        var n0_2 = try manager.getName("/foo/bar/bam");
        var n0_3 = try manager.getName("/foo/bar/bam");

        var n1 = try manager.getName("/foozln");

        // Check for same and unique names
        std.testing.expectEqual(n0_1, n0_2);
        std.testing.expectEqual(n0_2, n0_3);
        std.testing.expect(n0_1 != n1);

        var font_id = try manager.getName("/assets-in/font.tga");
        var potato_id = try manager.getName("/assets-in/potato.tga");
        var floor_id = try manager.getName("/assets-in/bad_floor.tga");

        const font_1 = try manager.get(font_id, 0x01);
        const font_2 = try manager.get(font_id, 0x01);
        const font_3 = try manager.get(font_id, 0x01);

        // we have one distinct resource loaded right now
        std.testing.expectEqual(@as(usize, 1), R.leak_counter);

        const potato = try manager.get(potato_id, 0x02);
        std.testing.expectEqual(@as(usize, 2), R.leak_counter);

        const floor = try manager.get(floor_id, 0x03);
        std.testing.expectEqual(@as(usize, 3), R.leak_counter);

        manager.collectGarbage();
        std.testing.expectEqual(@as(usize, 3), R.leak_counter);

        manager.releaseResources(0x02); // this marks potato for deletion
        std.testing.expectEqual(@as(usize, 3), R.leak_counter);

        manager.collectGarbage(); // this will release potato, but neither font nor floor
        std.testing.expectEqual(@as(usize, 2), R.leak_counter);

        manager.releaseResources(0x01); // this marks both font and floor for deletion
        std.testing.expectEqual(@as(usize, 2), R.leak_counter);

        manager.collectGarbage(); // this will release floor and font
        std.testing.expectEqual(@as(usize, 0), R.leak_counter);
    }
    // Check if interacting with the resource manager leaked any resources
    std.testing.expectEqual(@as(usize, 0), R.leak_counter);
}
