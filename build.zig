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
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run tests");
    inline for (exercisms) |e| {
        std.debug.print("added exercism {s}\n", .{e.name});
        const t = b.addTest(.{
            .root_source_file = .{ .path = e.getRootSourceFile() },
            .target = target,
            .optimize = optimize,
        });
        const t_run = b.addRunArtifact(t);
        test_step.dependOn(&t_run.step);
    }
}
