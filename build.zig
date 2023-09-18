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

const exercisms = [_]Exercism{
    Exercism{ .name = "collatz-conjecture" },
    Exercism{ .name = "leap" },
    Exercism{ .name = "difference-of-squares" },
    Exercism{ .name = "scrabble-score" },
    Exercism{ .name = "pangram" },
    Exercism{ .name = "armstrong-numbers" },
    Exercism{ .name = "isogram" },
    Exercism{ .name = "hamming" },
    Exercism{ .name = "grains" },
    Exercism{ .name = "isbn-verifier" },
    Exercism{ .name = "resistor-color" },
    Exercism{ .name = "resistor-color-duo" },
    Exercism{ .name = "luhn" },
    Exercism{ .name = "darts" },
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
