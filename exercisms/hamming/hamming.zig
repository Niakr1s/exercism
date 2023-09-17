const std = @import("std");

pub const DnaError = error{ EmptyDnaStrands, UnequalDnaStrands };

pub fn compute(first: []const u8, second: []const u8) DnaError!usize {
    if (first.len == 0 or second.len == 0) return DnaError.EmptyDnaStrands;
    if (first.len != second.len) return DnaError.UnequalDnaStrands;

    var diffs: usize = 0;
    for (first, second) |f, s| {
        if (f != s) diffs += 1;
    }
    return diffs;
}

const testing = std.testing;

test "empty strands" {
    const expected = DnaError.EmptyDnaStrands;

    const actual = compute("", "");

    try testing.expectError(expected, actual);
}

test "single letter identical strands" {
    const expected: usize = 0;

    const actual = try compute("A", "A");

    try testing.expectEqual(expected, actual);
}

test "single letter different strands" {
    const expected: usize = 1;

    const actual = try compute("G", "T");

    try testing.expectEqual(expected, actual);
}

test "long identical strands" {
    const expected: usize = 0;

    const actual = try compute("GGACTGAAATCTG", "GGACTGAAATCTG");

    try testing.expectEqual(expected, actual);
}

test "long different strands" {
    const expected: usize = 9;

    const actual = try compute("GGACGGATTCTG", "AGGACGGATTCT");

    try testing.expectEqual(expected, actual);
}

test "disallow first strand longer" {
    const expected = DnaError.UnequalDnaStrands;

    const actual = compute("AATG", "AAA");

    try testing.expectError(expected, actual);
}

test "disallow second strand longer" {
    const expected = DnaError.UnequalDnaStrands;

    const actual = compute("ATA", "AGTG");

    try testing.expectError(expected, actual);
}

test "disallow left empty strand" {
    const expected = DnaError.EmptyDnaStrands;

    const actual = compute("", "G");

    try testing.expectError(expected, actual);
}

test "disallow right empty strand" {
    const expected = DnaError.EmptyDnaStrands;

    const actual = compute("G", "");

    try testing.expectError(expected, actual);
}
