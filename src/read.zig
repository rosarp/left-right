const std = @import("std");
const assert = std.debug.assert;
const Value = std.atomic.Value;

const ReadHandleFactory = @import("read/factory.zig").ReadHandleFactory;

pub fn ReadHandle(comptime T: type) type {
    return extern struct {
        inner: T,
        epochs: Value(usize),
        epoch: Value(usize),
        epoch_i: usize,
        enters: usize,
        // _unimpl_send: T,

        const Self = @This();

        pub fn new(inner: T, epochs: Value(usize)) Self {
            return Self.new_with_arc(inner, epochs);
        }

        pub fn new_with_arc(inner: Value(T), epochs: Value(usize)) Self {
            const epoch = 0;
            const epoch_i = 1;

            return Self{
                epochs,
                epoch,
                epoch_i,
                0,
                inner,
                //
            };
        }

        pub fn factory(self: Self) ReadHandleFactory(T) {
            return ReadHandleFactory(T).init(self.inner, self.epochs);
        }

        pub fn enter(self: *Self) void {
            const enters = self.enters;
            if (enters != 0) {
                // We have already locked the epoch.
                // Just give out another guard.
            }
        }
    };
}
