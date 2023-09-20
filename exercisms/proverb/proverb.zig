const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

pub fn recite(allocator: mem.Allocator, words: []const []const u8) (fmt.AllocPrintError || mem.Allocator.Error)![][]u8 {
    var rhyme = std.ArrayList([]u8).init(allocator);

    if (words.len >= 2) {
        var window = std.mem.window([]const u8, words, 2, 1);
        while (window.next()) |word| {
            const line = try fmt.allocPrint(allocator, "For want of a {s} the {s} was lost.\n", .{ word[0], word[1] });
            try rhyme.append(line);
        }
    }

    if (words.len > 0) {
        const line = try fmt.allocPrint(allocator, "And all for the want of a {s}.\n", .{words[0]});
        try rhyme.append(line);
    }

    return rhyme.toOwnedSlice();
}

const testing = std.testing;

fn free(slices: [][]u8) void {
    for (slices) |s| {
        testing.allocator.free(s);
    }

    testing.allocator.free(slices); // No problem when `slices` has zero length.

}

test "zero pieces" {
    const input = [_][]const u8{};

    const expected = [_][]const u8{};

    const actual = try recite(testing.allocator, &input);

    defer free(actual);

    try testing.expectEqualSlices([]const u8, &expected, actual);
}

test "one piece" {
    const input = [_][]const u8{
        "nail",
    };

    const expected = [_][]const u8{
        "And all for the want of a nail.\n",
    };

    const actual = try recite(testing.allocator, &input);

    defer free(actual);

    for (expected, 0..) |expected_slice, i| {
        try testing.expectEqualSlices(u8, expected_slice, actual[i]);
    }
}

test "two pieces" {
    const input = [_][]const u8{
        "nail",

        "shoe",
    };

    const expected = [_][]const u8{
        "For want of a nail the shoe was lost.\n",

        "And all for the want of a nail.\n",
    };

    const actual = try recite(testing.allocator, &input);

    defer free(actual);

    for (expected, 0..) |expected_slice, i| {
        try testing.expectEqualSlices(u8, expected_slice, actual[i]);
    }
}

test "three pieces" {
    const input = [_][]const u8{
        "nail",

        "shoe",

        "horse",
    };

    const expected = [_][]const u8{
        "For want of a nail the shoe was lost.\n",

        "For want of a shoe the horse was lost.\n",

        "And all for the want of a nail.\n",
    };

    const actual = try recite(testing.allocator, &input);

    defer free(actual);

    for (expected, 0..) |expected_slice, i| {
        try testing.expectEqualSlices(u8, expected_slice, actual[i]);
    }
}

test "full proverb" {
    const input = [_][]const u8{
        "nail",

        "shoe",

        "horse",

        "rider",

        "message",

        "battle",

        "kingdom",
    };

    const expected = [_][]const u8{
        "For want of a nail the shoe was lost.\n",

        "For want of a shoe the horse was lost.\n",

        "For want of a horse the rider was lost.\n",

        "For want of a rider the message was lost.\n",

        "For want of a message the battle was lost.\n",

        "For want of a battle the kingdom was lost.\n",

        "And all for the want of a nail.\n",
    };

    const actual = try recite(testing.allocator, &input);

    defer free(actual);

    for (expected, 0..) |expected_slice, i| {
        try testing.expectEqualSlices(u8, expected_slice, actual[i]);
    }
}

test "four pieces modernized" {
    const input = [_][]const u8{
        "pin",

        "gun",

        "soldier",

        "battle",
    };

    const expected = [_][]const u8{
        "For want of a pin the gun was lost.\n",

        "For want of a gun the soldier was lost.\n",

        "For want of a soldier the battle was lost.\n",

        "And all for the want of a pin.\n",
    };

    const actual = try recite(testing.allocator, &input);

    defer free(actual);

    for (expected, 0..) |expected_slice, i| {
        try testing.expectEqualSlices(u8, expected_slice, actual[i]);
    }
}
