const std = @import("std");
const cwd = std.fs.cwd;

/// Filepath with exercism list
const exercism_txt_path = "exercisms/exercisms.txt";

const contents =
    \\const std = @import("std");
    \\const testing = std.testing;
    \\
;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    errdefer Args.printUsage();
    var args = try Args.parseArgs(allocator);

    try initExercismDir(allocator, args.name);

    onSuccess(args.name);
}

fn onSuccess(exercism_name: []const u8) void {
    std.debug.print(
        \\Created new exercism {0s}!
        \\
        \\Don't forget to add it in build.zig under 'exercisms' constant:
        \\
        \\const exercisms = [_]Exercism{{
        \\    ...
        \\    Exercism{{ .name = "{0s}" }},
        \\    ...
        \\}};
        \\
    , .{exercism_name});
}

/// Deprecated, not used anymore
fn appendExercismName(exercism_name: []const u8) !void {
    var exercism_txt_f = cwd().openFile(exercism_txt_path, .{ .mode = .write_only }) catch try std.fs.cwd().createFile(exercism_txt_path, .{});
    defer exercism_txt_f.close();

    try exercism_txt_f.seekFromEnd(0);
    _ = try exercism_txt_f.write("\n");
    _ = try exercism_txt_f.write(exercism_name);
}

fn initExercismDir(allocator: std.mem.Allocator, exercism_name: []const u8) !void {
    const dir_path = try std.fmt.allocPrint(allocator, "exercisms/{s}", .{exercism_name});
    defer allocator.free(dir_path);

    try cwd().makePath(dir_path);

    const zig_path = try std.fmt.allocPrint(allocator, "{s}/{s}.zig", .{ dir_path, exercism_name });
    defer allocator.free(zig_path);

    if (cwd().statFile(zig_path)) |_| {
        return error.PathAlreadyExists;
    } else |_| {}

    const zig_f = try cwd().createFile(zig_path, .{});
    defer zig_f.close();

    try zig_f.writeAll(contents);
}

const Args = struct {
    name: []const u8,

    const ParseArgsError = error{NoNameProvided};

    /// Parses args. Consumes iter.
    pub fn parseArgs(allocator: std.mem.Allocator) ParseArgsError!Args {
        var args_iter = try std.process.argsWithAllocator(allocator);
        defer args_iter.deinit();

        _ = args_iter.skip();
        const name = args_iter.next() orelse return ParseArgsError.NoNameProvided;
        return Args{ .name = name };
    }

    pub fn printUsage() void {
        std.debug.print(
            \\Usage:
            \\  ./program [name-of-new-exercism]
            \\
            \\
        , .{});
    }
};
