const std = @import("std");
const Value = std.atomic.Value;
const ReadHandle = @import("../read.zig").ReadHandle;

pub fn ReadHandleFactory(comptime T: type) type {
    return extern struct {
        inner: Value(T),
        epochs: Value(usize),

        const Self = @This();

        pub fn init(self: *Self, inner: Value(T), epochs: Value(usize)) Self {
            self.inner = inner;
            self.epochs = epochs;
        }

        pub fn handle(self: *Self) ReadHandle(T) {
            return ReadHandle(T).new_with_arc(self.inner, self.epochs);
        }
    };
}
