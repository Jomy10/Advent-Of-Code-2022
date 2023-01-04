const std = @import("std");
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();
const parseInput = @import("input.zig").parseInput;
const construction = @import("construction.zig");
const Crate = construction.Crate;
const popCrate = construction.popCrate;
const popNCrates = construction.popNCrates;
const pushCrate = construction.pushCrate;
const freeCrane = construction.freeCrane;
const topCrates = construction.topCrates;
const printStack = construction.printStack;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input_file: []const u8 = "input.txt";
    var crane9000 = try parseInput(allocator, input_file);
    defer freeCrane(allocator, &crane9000);

    // Part 1
    for (crane9000.instructions) |instruction| {
        var i: u32 = 0;
        while (i < instruction.amt) : (i += 1) {
            const crate_opt: ?Crate = popCrate(&crane9000.stacks[instruction.from - 1]);
            if (crate_opt) |crate| {
                try pushCrate(allocator, &crane9000.stacks[instruction.to - 1], crate);
            } else {
                try stderr.print("Could't pop crate off stack {}\n", .{instruction.from});
                @panic("Program exited with error");
            }
        }
    }

    const top_crates = try topCrates(allocator, crane9000.stacks);
    defer allocator.free(top_crates);
    try stdout.print("Part 1: {s}\n", .{top_crates});

    // Part 2
    var crane9001 = try parseInput(allocator, input_file);
    defer freeCrane(allocator, &crane9001);

    for (crane9001.instructions) |instruction| {
        const crates_opt = popNCrates(&crane9001.stacks[instruction.from - 1], instruction.amt);
        if (crates_opt) |crates| {
            var i: u32 = 0;
            while (i < instruction.amt) : (i += 1) {
                try pushCrate(allocator, &crane9001.stacks[instruction.to - 1], crates[i]);
            }
        } else {
            try stderr.print("Could't pop crate off stack {}\n", .{instruction.from});
            @panic("Program exited with error");
        }
    }

    const top_crates2 = try topCrates(allocator, crane9001.stacks);
    defer allocator.free(top_crates2);
    try stdout.print("Part 2: {s}\n", .{top_crates2});
}
