const std = @import("std");
const mem = std.mem;
const stderr = std.io.getStdErr().writer();

pub const Crate = struct {
    name: u8,
};

pub const Stack = struct {
    crates: []Crate,
    crates_cap: u32,
    // Deprecated
    crates_len: u32,
};

pub const Instruction = struct {
    amt: u32,
    from: u32,
    to: u32,
};

pub const CraneInstr = struct {
    stacks: []Stack,
    instructions: []Instruction,
};

pub fn freeCrane(allocator: mem.Allocator, crane: *CraneInstr) void {
    var i: u32 = 0;
    while (i < crane.stacks.len) : (i += 1) {
        allocator.free(crane.stacks[i].crates);
    }
    allocator.free(crane.stacks);
    allocator.free(crane.instructions);
}

/// Reverse a stack
pub fn reverseStack(allocator: mem.Allocator, stack: *Stack) !void {
    var crates_old = stack.crates;
    var crates_new = try allocator.alloc(Crate, stack.crates_cap);
    var oi: u32 = stack.crates_len;
    var ni: u32 = 0;
    while (ni < stack.crates_len) : (ni += 1) {
        oi -= 1;
        // while (oi >= 0) : (oi -= 1) {
        crates_new[ni] = crates_old[oi];
        // ni += 1;
    }
    stack.crates = crates_new;
    allocator.free(crates_old);
}

/// Pop one crate off the stack
pub fn popCrate(stack: *Stack) ?Crate {
    if (stack.crates_len == 0) return null;
    const crate = stack.crates[stack.crates_len - 1];
    stack.crates_len -= 1;
    return crate;
}

/// Take `n` crates off the stack and keep their order
pub fn popNCrates(stack: *Stack, n: u32) ?[*]Crate {
    if (stack.crates_len == n - 1) {
        stderr.print("Len is {}, n is {}\n", .{ stack.crates_len, n }) catch {};
        return null;
    }
    const crates_ptr: [*]Crate = @ptrCast([*]Crate, &stack.crates[stack.crates_len - n]);
    stack.crates_len -= n;
    return crates_ptr;
}

/// Push a crate onto a stack
pub fn pushCrate(allocator: mem.Allocator, stack: *Stack, crate: Crate) !void {
    if (stack.crates_len == stack.crates_cap) {
        stack.crates_cap *= 2;
        stack.crates = try allocator.realloc(stack.crates, stack.crates_cap);
    }
    stack.crates_len += 1;
    stack.crates[stack.crates_len - 1] = crate;
}

/// get the names of all the crates on the top of the stacks
pub fn topCrates(allocator: mem.Allocator, stacks: []Stack) ![]u8 {
    var answer = try allocator.alloc(u8, stacks.len);
    var i: u32 = 0;
    while (i < stacks.len) : (i += 1) {
        answer[i] = stacks[i].crates[stacks[i].crates_len - 1].name;
    }
    return answer;
}

/// print a stack for debugging
pub fn printStack(stack: *Stack) !void {
    var i: usize = stack.crates_len;
    while (i > 0) {
        i -= 1;
        try stderr.print("[{c}]\n", .{stack.crates[i].name});
    }
}
