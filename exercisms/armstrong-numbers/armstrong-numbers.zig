const std = @import("std");

pub fn isArmstrongNumber(num: u128) bool {
    var buf: [40]u8 = undefined; // maximum 40 digits in num
    const int_str = std.fmt.bufPrintIntToSlice(&buf, num, 10, .lower, .{});
    var res: u128 = 0;
    for (int_str) |ch| {
        res += std.math.pow(u128, @as(u128, ch - '0'), int_str.len);
    }
    return res == num;
}

const testing = std.testing;

test "zero is an armstrong number" {
    try testing.expect(isArmstrongNumber(0));
}

test "single-digit numbers are armstrong numbers" {
    try testing.expect(isArmstrongNumber(5));
}

test "there are no two-digit armstrong numbers" {
    try testing.expect(!isArmstrongNumber(10));
}

test "three-digit number that is an armstrong number" {
    try testing.expect(isArmstrongNumber(153));
}

test "three-digit number that is not an armstrong number" {
    try testing.expect(!isArmstrongNumber(100));
}

test "four-digit number that is an armstrong number" {
    try testing.expect(isArmstrongNumber(9_474));
}

test "four-digit number that is not an armstrong number" {
    try testing.expect(!isArmstrongNumber(9_475));
}

test "seven-digit number that is an armstrong number" {
    try testing.expect(isArmstrongNumber(9_926_315));
}

test "seven-digit number that is not an armstrong number" {
    try testing.expect(!isArmstrongNumber(9_926_314));
}

test "33-digit number that is an armstrong number" {
    try testing.expect(isArmstrongNumber(186_709_961_001_538_790_100_634_132_976_990));
}

test "38-digit number that is not an armstrong number" {
    try testing.expect(!isArmstrongNumber(99_999_999_999_999_999_999_999_999_999_999_999_999));
}

test "the largest and last armstrong number" {
    try testing.expect(isArmstrongNumber(115_132_219_018_763_992_565_095_597_973_971_522_401));
}

test "the largest 128-bit unsigned integer value is not an armstrong number" {
    try testing.expect(!isArmstrongNumber(340_282_366_920_938_463_463_374_607_431_768_211_455));
}
