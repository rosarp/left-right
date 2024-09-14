const std = @import("std");
const assert = std.debug.assert;

const Value = std.atomic.Value;
const ArrayList = std.ArrayList;
const Absorb = @import("root.zig");

pub fn WriteHandle(comptime O: type, comptime T: Absorb(O)) type {
    return extern struct {
        epochs: Value(usize),
        w_handle: T,
        oplog: ArrayList(O),
        swap_index: usize,
        r_handle: T,
        last_epochs: ArrayList(usize),
        refreshes: usize,
        is_waiting: bool,
        first: bool,
        second: bool,
        taken: bool,

        const Self = @This();

        pub fn take_inner(self: *Self) ?Taken(O, T) {
            if (self.taken == true) {
                return null;
            }

            // Disallow taking again.
            self.taken = true;

            // first, ensure both copies are up to date
            // (otherwise safely dropping the possibly duplicated w_handle data is a pain)
            if (self.first || self.oplog.items.len != 0) {
                self.publish();
            }
            if (self.oplog.items.len != 0) {
                self.publish();
            }
            assert(self.oplog.items.len == 0);

            // next, grab the read handle and set it to NULL
            self.r_handle;
        }
    };
}

pub fn Taken(comptime O: type, comptime T: Absorb(O)) type {
    return extern struct {
        inner: ?T,
        marker: O,

        const Self = @This();

        fn drop(self: *Self) void {
            T.drop_second(self.inner);
        }
    };
}
