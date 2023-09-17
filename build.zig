const std = @import("std");

/// Each exercisms should be under src folder, each in separate folders.
/// File name should be equal folder name, and this is our name field.
const Exercism = struct {
    /// Stem of file name, which should be equal directory name.
    name: []const u8,
};

const exercisms = [_]Exercism{
    Exercism{ .name = "collatz-conjecture" },
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run tests");
    inline for (exercisms) |e| {
        const t = b.addTest(.{
            .root_source_file = .{ .path = "src/" ++ e.name ++ "/" ++ e.name ++ ".zig" },
            .target = target,
            .optimize = optimize,
        });
        const t_run = b.addRunArtifact(t);
        test_step.dependOn(&t_run.step);
    }
}
