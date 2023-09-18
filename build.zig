const std = @import("std");

/// Each exercisms should be under src folder, each in separate folders.
/// File name should be equal folder name, and this is our name field.
const Exercism = struct {
    /// Stem of file name, which should be equal directory name.
    name: []const u8,

    fn getRootSourceFile(comptime self: Exercism) []const u8 {
        return "exercisms/" ++ self.name ++ "/" ++ self.name ++ ".zig";
    }
};

const exercism_names = @embedFile("exercisms/exercisms.txt");

const exercisms = blk: {
    var tokens = std.mem.tokenizeAny(u8, exercism_names, "\n");
    var buf = sliceFromIter(Exercism, &tokens);
    var i: usize = 0;
    inline while (tokens.next()) |token| : (i += 1) {
        buf[i] = Exercism{ .name = token };
    }
    break :blk buf;
};

const BuildOptions = struct {
    target: std.zig.CrossTarget,
    optimize: std.builtin.Mode,
};

pub fn build(b: *std.Build) void {
    const build_options = BuildOptions{
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    };

    addTests(b, build_options);
    addNewExercismExe(b, build_options);
}

fn addTests(b: *std.Build, build_options: BuildOptions) void {
    const run = b.step("test", "Run tests");
    inline for (exercisms, 1..) |e, i| {
        std.debug.print("[{d:3}] added exercism '{s}'\n", .{ i, e.name });
        const compile = b.addTest(.{
            .root_source_file = .{ .path = e.getRootSourceFile() },
            .target = build_options.target,
            .optimize = build_options.optimize,
        });
        const cmd = b.addRunArtifact(compile);
        run.dependOn(&cmd.step);
    }
}

fn addNewExercismExe(b: *std.Build, build_options: BuildOptions) void {
    const compile = b.addExecutable(.{
        .name = "new-exercism",
        .root_source_file = .{ .path = "cmd/new-exercism/new-exercism.zig" },
        .target = build_options.target,
        .optimize = build_options.optimize,
    });
    b.installArtifact(compile);
    const cmd = b.addRunArtifact(compile);
    if (b.args != null) cmd.addArgs(b.args.?);

    const run = b.step("new-exercism", "Add new exercism");
    run.dependOn(&cmd.step);
}

/// Makes slice with capacity, enough to hold all items in iterator.
/// Resets iter.
fn sliceFromIter(comptime T: type, iter: anytype) []T {
    iter.reset();

    var i: usize = 0;
    inline while (iter.next()) |_| : (i += 1) {}
    iter.reset();

    var res: [i]T = undefined;
    return &res; // I guess it's safe to return variable on stack in comptime fn?
}
