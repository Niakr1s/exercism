const std = @import("std");

pub const ChessboardError = error{IndexOutOfBounds};

pub fn square(index: usize) ChessboardError!u64 {
    if (index < 1 or index > 64) return ChessboardError.IndexOutOfBounds;
    return std.math.pow(u64, 2, index - 1);
}

pub fn total() u64 {
    var res: u64 = 0;
    for (0..64) |i| {
        res += square(i + 1) catch unreachable;
    }
    return res;
}

const testing = std.testing;

test "grains on square 1" {
    const expected: u64 = 1;
    const actual = try square(1);
    try testing.expectEqual(expected, actual);
}

test "grains on square 2" {
    const expected: u64 = 2;
    const actual = try square(2);
    try testing.expectEqual(expected, actual);
}

test "grains on square 3" {
    const expected: u64 = 4;
    const actual = try square(3);
    try testing.expectEqual(expected, actual);
}

test "grains on square 4" {
    const expected: u64 = 8;
    const actual = try square(4);
    try testing.expectEqual(expected, actual);
}

test "grains on square 16" {
    const expected: u64 = 32_768;
    const actual = try square(16);
    try testing.expectEqual(expected, actual);
}

test "grains on square 32" {
    const expected: u64 = 2_147_483_648;
    const actual = try square(32);
    try testing.expectEqual(expected, actual);
}

test "grains on square 64" {
    const expected: u64 = 9_223_372_036_854_775_808;
    const actual = try square(64);
    try testing.expectEqual(expected, actual);
}

test "square 0 produces an error" {
    const expected = ChessboardError.IndexOutOfBounds;
    const actual = square(0);
    try testing.expectError(expected, actual);
}

test "square greater than 64 produces an error" {
    const expected = ChessboardError.IndexOutOfBounds;
    const actual = square(65);
    try testing.expectError(expected, actual);
}

test "returns the total number of grains on the board" {
    const expected: u64 = 18_446_744_073_709_551_615;
    const actual = total();
    try testing.expectEqual(expected, actual);
}
