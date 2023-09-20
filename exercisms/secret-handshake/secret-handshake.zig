const std = @import("std");
const mem = std.mem;

pub const Signal = enum(u8) {
    wink = 1 << 0,
    double_blink = 1 << 1,
    close_your_eyes = 1 << 2,
    jump = 1 << 3,
};

const reverse = 1 << 4;

pub fn calculateHandshake(allocator: mem.Allocator, number: isize) mem.Allocator.Error![]const Signal {
    var res = std.ArrayList(Signal).init(allocator);

    for (std.enums.values(Signal)) |s| {
        if (@intFromEnum(s) & number != 0) try res.append(s);
    }
    if (number & reverse != 0) std.mem.reverse(Signal, res.items);
    return res.toOwnedSlice();
}

const testing = std.testing;

test "wink for 1" {
    const expected = &[_]Signal{.wink};

    const actual = try calculateHandshake(testing.allocator, 1);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "double blink for 10" {
    const expected = &[_]Signal{.double_blink};

    const actual = try calculateHandshake(testing.allocator, 2);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "close your eyes for 100" {
    const expected = &[_]Signal{.close_your_eyes};

    const actual = try calculateHandshake(testing.allocator, 4);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "jump for 1000" {
    const expected = &[_]Signal{.jump};

    const actual = try calculateHandshake(testing.allocator, 8);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "combine two actions" {
    const expected = &[_]Signal{ .wink, .double_blink };

    const actual = try calculateHandshake(testing.allocator, 3);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "reverse two actions" {
    const expected = &[_]Signal{ .double_blink, .wink };

    const actual = try calculateHandshake(testing.allocator, 19);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "reversing one action gives the same action" {
    const expected = &[_]Signal{.jump};

    const actual = try calculateHandshake(testing.allocator, 24);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "reversing no actions still gives no actions" {
    const expected = &[_]Signal{};

    const actual = try calculateHandshake(testing.allocator, 16);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "all possible actions" {
    const expected = &[_]Signal{ .wink, .double_blink, .close_your_eyes, .jump };

    const actual = try calculateHandshake(testing.allocator, 15);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "reverse all possible actions" {
    const expected = &[_]Signal{ .jump, .close_your_eyes, .double_blink, .wink };

    const actual = try calculateHandshake(testing.allocator, 31);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "do nothing for zero" {
    const expected = &[_]Signal{};

    const actual = try calculateHandshake(testing.allocator, 0);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}
