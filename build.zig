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

const BuildOptions = struct {
    target: std.zig.CrossTarget,
    optimize: std.builtin.Mode,
};

pub fn build(b: *std.Build) !void {
    const build_options = BuildOptions{
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    };

    try addTests(b, build_options);
    addNewExercismExe(b, build_options);
}

fn addTests(b: *std.Build, build_options: BuildOptions) !void {
    const run = b.step("test", "Run tests");

    const dir_path = "exercisms";
    const cwd = std.fs.cwd();
    try cwd.makePath(dir_path);
    var exercism_dir = try cwd.openIterableDir(dir_path, .{});
    var exercism_dir_iter = exercism_dir.iterate();

    while (try exercism_dir_iter.next()) |item| {
        if (item.kind == .directory) {
            const name: []const u8 = item.name;

            const path = try std.fmt.allocPrint(b.allocator, "{0s}/{1s}/{1s}.zig", .{ dir_path, name });
            defer b.allocator.free(path);

            if (cwd.statFile(path)) |_| {
                const compile = b.addTest(.{
                    .root_source_file = .{ .path = path },
                    .target = build_options.target,
                    .optimize = build_options.optimize,
                });
                std.debug.print("[  OK] [Exercism]   Added: '{s}'\n", .{path});
                const cmd = b.addRunArtifact(compile);
                run.dependOn(&cmd.step);
            } else |_| {
                std.debug.print("[FAIL] [Exercism] Missing: '{s}'\n", .{path});
            }
        }
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
