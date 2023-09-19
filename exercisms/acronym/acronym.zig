const std = @import("std");
const mem = std.mem;
const testing = std.testing;

pub fn abbreviate(allocator: mem.Allocator, words: []const u8) mem.Allocator.Error![]u8 {
    var res = std.ArrayList(u8).init(allocator);
    defer res.deinit();

    var iter = std.mem.tokenizeAny(u8, words, std.ascii.whitespace ++ "-");
    while (iter.next()) |w| {
        for (w) |c| {
            if (std.ascii.isAlphabetic(c)) {
                try res.append(std.ascii.toUpper(c));
                break;
            }
        }
    }
    return res.toOwnedSlice();
}

test "basic" {
    const expected = "PNG";

    const actual = try abbreviate(testing.allocator, "Portable Network Graphics");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "lowercase words" {
    const expected = "ROR";

    const actual = try abbreviate(testing.allocator, "Ruby on Rails");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "punctuation" {
    const expected = "FIFO";

    const actual = try abbreviate(testing.allocator, "First In, First Out");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "all caps word" {
    const expected = "GIMP";

    const actual = try abbreviate(testing.allocator, "GNU Image Manipulation Program");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "punctuation without whitespace" {
    const expected = "CMOS";

    const actual = try abbreviate(testing.allocator, "Complementary metal-oxide semiconductor");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "very long abbreviation" {
    const expected = "ROTFLSHTMDCOALM";

    const actual = try abbreviate(testing.allocator, "Rolling On The Floor Laughing So Hard That My Dogs Came Over And Licked Me");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "consecutive delimiters" {
    const expected = "SIMUFTA";

    const actual = try abbreviate(testing.allocator, "Something - I made up from thin air");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "apostrophes" {
    const expected = "HC";

    const actual = try abbreviate(testing.allocator, "Halley's Comet");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "underscore emphasis" {
    const expected = "TRNT";

    const actual = try abbreviate(testing.allocator, "The Road _Not_ Taken");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}
