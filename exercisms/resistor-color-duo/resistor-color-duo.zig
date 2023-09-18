const std = @import("std");

pub const ColorBand = enum(u8) {
    black,
    brown,
    red,
    orange,
    yellow,
    green,
    blue,
    violet,
    grey,
    white,
};

pub fn colorCode(colors: [2]ColorBand) usize {
    return @intFromEnum(colors[0]) * 10 + @intFromEnum(colors[1]);
}

const testing = std.testing;

test "brown and black" {
    const array = [_]ColorBand{ .brown, .black };
    const expected: usize = 10;
    const actual = colorCode(array);
    try testing.expectEqual(expected, actual);
}

test "blue and grey" {
    const array = [_]ColorBand{ .blue, .grey };
    const expected: usize = 68;
    const actual = colorCode(array);
    try testing.expectEqual(expected, actual);
}

test "yellow and violet" {
    const array = [_]ColorBand{ .yellow, .violet };
    const expected: usize = 47;
    const actual = colorCode(array);
    try testing.expectEqual(expected, actual);
}

test "white and red" {
    const array = [_]ColorBand{ .white, .red };
    const expected: usize = 92;
    const actual = colorCode(array);
    try testing.expectEqual(expected, actual);
}

test "orange and orange" {
    const array = [_]ColorBand{ .orange, .orange };
    const expected: usize = 33;
    const actual = colorCode(array);
    try testing.expectEqual(expected, actual);
}

test "black and brown, one-digit" {
    const array = [_]ColorBand{ .black, .brown };
    const expected: usize = 1;
    const actual = colorCode(array);
    try testing.expectEqual(expected, actual);
}
