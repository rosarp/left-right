const std = @import("std");
const testing = std.testing;

const WriteHandle = @import("write.zig").WriteHandle;
const ReadHandle = @import("read.zig").ReadHandle;

pub fn Absorb(comptime O: type) type {
    return extern struct {
        raw: O,
        absorb_first_fn: *const fn (ptr: *Self) void,
        drop_first_fn: *const fn (ptr: *Self) void,
        drop_second_fn: *const fn (ptr: *Self) void,
        sync_with_fn: *const fn (ptr: *Self, first: *Self) void,

        const Self = @This();

        pub fn init(value: O) Self {
            return .{ .raw = value };
        }

        fn absorb_first(self: *Self, operation: anytype, other: *Self) void {
            self.absorb_first_fn(self, operation, other);
        }

        fn absorb_second(self: *Self, operation: anytype, other: *Self) void {
            self.absorb_first(self, operation, other);
        }

        fn drop_first(self: *Self) void {
            self.drop_first_fn(self);
        }

        fn drop_second(self: *Self) void {
            self.drop_second_fn(self);
        }

        fn sync_with(self: *Self, first: *Self) void {
            self.sync_with_fn(self, first);
        }
    };
}

test "basic add functionality" {}
