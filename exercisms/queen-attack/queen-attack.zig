const std = @import("std");
const testing = std.testing;

pub const QueenError = error{
    InitializationFailure,
};

pub const Queen = struct {
    row: i8,
    col: i8,

    pub fn init(row: i8, col: i8) QueenError!Queen {
        if (!(row >= 0 and row < 8) or !(col >= 0 and col < 8)) {
            return QueenError.InitializationFailure;
        }
        return Queen{ .row = row, .col = col };
    }

    pub fn canAttack(self: Queen, other: Queen) QueenError!bool {
        const on_diag = std.math.absCast(self.col - other.col) == std.math.absCast(self.row - other.row);
        return on_diag or self.row == other.row or self.col == other.col;
    }
};

test "queen has exactly two fields" {
    try testing.expectEqual(2, std.meta.fields(Queen).len);
}

test "queen with a valid position" {
    const queen = try Queen.init(2, 2);
    // Allow the fields to have any name.

    const fields = std.meta.fields(@TypeOf(queen));
    inline for (fields) |f| {
        const actual = @field(queen, f.name);
        const expected = @as(@TypeOf(actual), 2);
        try testing.expectEqual(expected, actual);
    }
}

test "queen must have positive row" {
    const queen = Queen.init(-2, 2);
    try testing.expectError(QueenError.InitializationFailure, queen);
}

test "queen must have row on board" {
    const queen = Queen.init(8, 4);
    try testing.expectError(QueenError.InitializationFailure, queen);
}

test "queen must have positive column" {
    const queen = Queen.init(2, -2);
    try testing.expectError(QueenError.InitializationFailure, queen);
}

test "queen must have column on board" {
    const queen = Queen.init(4, 8);
    try testing.expectError(QueenError.InitializationFailure, queen);
}

test "cannot attack" {
    const white = try Queen.init(2, 4);
    const black = try Queen.init(6, 6);
    try testing.expect(!try white.canAttack(black));
}

test "can attack on same row" {
    const white = try Queen.init(2, 4);
    const black = try Queen.init(2, 6);
    try testing.expect(try white.canAttack(black));
}

test "can attack on same column" {
    const white = try Queen.init(4, 5);
    const black = try Queen.init(2, 5);
    try testing.expect(try white.canAttack(black));
}

test "can attack on first diagonal" {
    const white = try Queen.init(2, 2);
    const black = try Queen.init(0, 4);
    try testing.expect(try white.canAttack(black));
}

test "can attack on second diagonal" {
    const white = try Queen.init(2, 2);
    const black = try Queen.init(3, 1);
    try testing.expect(try white.canAttack(black));
}

test "can attack on third diagonal" {
    const white = try Queen.init(2, 2);
    const black = try Queen.init(1, 1);
    try testing.expect(try white.canAttack(black));
}

test "can attack on fourth diagonal" {
    const white = try Queen.init(1, 7);
    const black = try Queen.init(0, 6);
    try testing.expect(try white.canAttack(black));
}

test "cannot attack if falling diagonals are only the same when reflected across the longest falling diagonal" {
    const white = try Queen.init(4, 1);
    const black = try Queen.init(2, 5);
    try testing.expect(!try white.canAttack(black));
}
