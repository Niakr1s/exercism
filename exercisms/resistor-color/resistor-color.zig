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

pub fn colorCode(color: ColorBand) usize {
    return @intFromEnum(color);
}

pub fn colors() []const ColorBand {
    return std.enums.values(ColorBand);
}

const testing = std.testing;

test "black" {
    const expected: usize = 0;
    const actual = colorCode(.black);
    try testing.expectEqual(expected, actual);
}

test "white" {
    const expected: usize = 9;
    const actual = colorCode(.white);
    try testing.expectEqual(expected, actual);
}

test "orange" {
    const expected: usize = 3;
    const actual = colorCode(.orange);
    try testing.expectEqual(expected, actual);
}

test "colors" {
    const expected = &[_]ColorBand{
        .black, .brown, .red,    .orange, .yellow,
        .green, .blue,  .violet, .grey,   .white,
    };

    const actual = colors();
    try testing.expectEqualSlices(ColorBand, expected, actual);
}
