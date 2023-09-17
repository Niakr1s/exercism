const std = @import("std");
const testing = std.testing;

pub const ComputationError = error{IllegalArgument};

pub fn steps(number: usize) ComputationError!usize {
    if (number <= 0) return error.IllegalArgument;

    var num = number;
    var count: usize = 0;
    while (num != 1) : (count += 1) {
        num = switch (num % 2) {
            0 => num / 2,
            1 => num * 3 + 1,
            else => unreachable,
        };
    }
    return count;
}

test "steps" {
    const expected = [_]anyerror!usize{ 0, 4, 9, 152, error.IllegalArgument };
    const inputs = [_]usize{ 1, 16, 12, 1_000_000, 0 };

    for (expected, inputs) |e, i| {
        try std.testing.expectEqual(e, steps(i));
    }
}
