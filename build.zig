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

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run tests");
    inline for (exercisms, 1..) |e, i| {
        std.debug.print("[{d:3}] added exercism '{s}'\n", .{ i, e.name });
        const t = b.addTest(.{
            .root_source_file = .{ .path = e.getRootSourceFile() },
            .target = target,
            .optimize = optimize,
        });
        const t_run = b.addRunArtifact(t);
        test_step.dependOn(&t_run.step);
    }

    addNewExercismExe(b);
}

fn addNewExercismExe(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "new-exercism",
        .root_source_file = .{ .path = "cmd/new-exercism/new-exercism.zig" },
    });
    b.installArtifact(exe);
    const run = b.addRunArtifact(exe);
    if (b.args != null) run.addArgs(b.args.?);

    const step = b.step("new-exercism", "Add new exercism");
    step.dependOn(&run.step);
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
