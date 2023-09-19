const std = @import("std");
const mem = std.mem;

pub fn isBalanced(allocator: mem.Allocator, s: []const u8) !bool {
    var stack = std.ArrayList(u8).init(allocator);
    defer stack.deinit();

    for (s) |c| {
        switch (c) {
            '[' => try stack.append(']'),
            '(' => try stack.append(')'),
            '{' => try stack.append('}'),
            '}', ')', ']' => {
                if (stack.popOrNull() != c) {
                    return false;
                }
            },
            else => {},
        }
    }
    return stack.items.len == 0;
}

const testing = std.testing;

test "paired square brackets" {
    const actual = try isBalanced(testing.allocator, "[]");

    try testing.expect(actual);
}

test "empty string" {
    const actual = try isBalanced(testing.allocator, "");

    try testing.expect(actual);
}

test "unpaired brackets" {
    const actual = try isBalanced(testing.allocator, "[[");

    try testing.expect(!actual);
}

test "wrong ordered brackets" {
    const actual = try isBalanced(testing.allocator, "}{");

    try testing.expect(!actual);
}

test "wrong closing bracket" {
    const actual = try isBalanced(testing.allocator, "{]");

    try testing.expect(!actual);
}

test "paired with whitespace" {
    const actual = try isBalanced(testing.allocator, "{ }");

    try testing.expect(actual);
}

test "partially paired brackets" {
    const actual = try isBalanced(testing.allocator, "{[])");

    try testing.expect(!actual);
}

test "simple nested brackets" {
    const actual = try isBalanced(testing.allocator, "{[]}");

    try testing.expect(actual);
}

test "several paired brackets" {
    const actual = try isBalanced(testing.allocator, "{}[]");

    try testing.expect(actual);
}

test "paired and nested brackets" {
    const actual = try isBalanced(testing.allocator, "([{}({}[])])");

    try testing.expect(actual);
}

test "unopened closing brackets" {
    const actual = try isBalanced(testing.allocator, "{[)][]}");

    try testing.expect(!actual);
}

test "unpaired and nested brackets" {
    const actual = try isBalanced(testing.allocator, "([{])");

    try testing.expect(!actual);
}

test "paired and wrong nested brackets" {
    const actual = try isBalanced(testing.allocator, "[({]})");

    try testing.expect(!actual);
}

test "paired and wrong nested brackets but innermost are correct" {
    const actual = try isBalanced(testing.allocator, "[({}])");

    try testing.expect(!actual);
}

test "paired and incomplete brackets" {
    const actual = try isBalanced(testing.allocator, "{}[");

    try testing.expect(!actual);
}

test "too many closing brackets" {
    const actual = try isBalanced(testing.allocator, "[]]");

    try testing.expect(!actual);
}

test "early unexpected brackets" {
    const actual = try isBalanced(testing.allocator, ")()");

    try testing.expect(!actual);
}

test "early mismatched brackets" {
    const actual = try isBalanced(testing.allocator, "{)()");

    try testing.expect(!actual);
}

test "math expression" {
    const actual = try isBalanced(testing.allocator, "(((185 + 223.85) * 15) - 543)/2");

    try testing.expect(actual);
}

test "complex latex expression" {
    const s = "\\left(\\begin{array}{cc} \\frac{1}{3} & x\\\\ \\mathrm{e}^{x} &... x^2 \\end{array}\\right)";

    const actual = try isBalanced(testing.allocator, s);

    try testing.expect(actual);
}

test "maximum required level of nesting" {
    const s = "(((_[[[_{{{_()_}}}_]]]_)))";

    const actual = try isBalanced(testing.allocator, s);

    try testing.expect(actual);
}
