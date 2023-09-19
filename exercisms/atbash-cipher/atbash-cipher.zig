const std = @import("std");
const testing = std.testing;
const mem = std.mem;

/// Encodes `s` using the Atbash cipher. Caller owns the returned memory.
pub fn encode(allocator: mem.Allocator, s: []const u8) mem.Allocator.Error![]u8 {
    var res = std.ArrayList(u8).init(allocator);
    defer res.deinit();

    for (s) |c| {
        if (chEnc(c)) |enc_c| {
            try res.append(enc_c);
            if (res.items.len % 6 == 5) try res.append(' ');
        } else |_| {}
    }
    if (res.getLastOrNull() == ' ') {
        _ = res.pop();
    }

    return res.toOwnedSlice();
}

/// Decodes `s` using the Atbash cipher. Caller owns the returned memory.
pub fn decode(allocator: mem.Allocator, s: []const u8) mem.Allocator.Error![]u8 {
    var res = std.ArrayList(u8).init(allocator);
    defer res.deinit();

    for (s) |c| {
        if (chDec(c)) |dec_c| {
            if (dec_c != null) try res.append(dec_c.?);
        } else |_| {}
    }

    return res.toOwnedSlice();
}

const EndcodingError = error{InvalidCharacter};

fn chEnc(c: u8) EndcodingError!u8 {
    if (c >= '0' and c <= '9') {
        return c;
    } else if (std.ascii.isAlphabetic(c)) {
        const n: u8 = std.ascii.toLower(c) - 'a';
        return 'z' - n;
    }
    return error.InvalidCharacter;
}

fn chDec(c: u8) EndcodingError!?u8 {
    if (c >= '0' and c <= '9') {
        return c;
    } else if (c >= 'a' and c <= 'z') {
        return 'z' - (c - 'a');
    } else if (c == ' ') {
        return null;
    }
    return error.InvalidCharacter;
}

test "encode yes" {
    const expected = "bvh";

    const s = "yes";

    const actual = try encode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "encode no" {
    const expected = "ml";

    const s = "no";

    const actual = try encode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "encode omg" {
    const expected = "lnt";

    const s = "OMG";

    const actual = try encode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "encode spaces" {
    const expected = "lnt";

    const s = "O M G";

    const actual = try encode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "encode mindblowingly" {
    const expected = "nrmwy oldrm tob";

    const s = "mindblowingly";

    const actual = try encode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "encode numbers" {
    const expected = "gvhgr mt123 gvhgr mt";

    const s = "Testing,1 2 3, testing.";

    const actual = try encode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "encode deep thought" {
    const expected = "gifgs rhurx grlm";

    const s = "Truth is fiction.";

    const actual = try encode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "encode all the letters" {
    const expected = "gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt";

    const s = "The quick brown fox jumps over the lazy dog.";

    const actual = try encode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "decode exercism" {
    const expected = "exercism";

    const s = "vcvix rhn";

    const actual = try decode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "decode a sentence" {
    const expected = "anobstacleisoftenasteppingstone";

    const s = "zmlyh gzxov rhlug vmzhg vkkrm thglm v";

    const actual = try decode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "decode numbers" {
    const expected = "testing123testing";

    const s = "gvhgr mt123 gvhgr mt";

    const actual = try decode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "decode all the letters" {
    const expected = "thequickbrownfoxjumpsoverthelazydog";

    const s = "gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt";

    const actual = try decode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "decode with too many spaces" {
    const expected = "exercism";

    const s = "vc vix    r hn";

    const actual = try decode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "decode with no spaces" {
    const expected = "anobstacleisoftenasteppingstone";

    const s = "zmlyhgzxovrhlugvmzhgvkkrmthglmv";

    const actual = try decode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}
