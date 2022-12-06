const std = @import("std");
const mem = std.mem;
const construction = @import("construction.zig");
const Crate = construction.Crate;
const Stack = construction.Stack;
const Instruction = construction.Instruction;
const CraneInstr = construction.CraneInstr;
const reverseStack = construction.reverseStack;

pub fn parseInput(allocator: mem.Allocator, file_name: []const u8) !CraneInstr {
    var file = try std.fs.cwd().openFile(file_name, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var lines_buf: [1024][1024]u8 = undefined;

    var lines_crates_cap: u32 = 128;
    var lines_crates_len: u32 = 0;
    var lines_crates: [][]u8 = try allocator.alloc([]u8, lines_crates_cap);
    defer allocator.free(lines_crates);

    var lines_instr_cap: u32 = 128;
    var lines_instr_len: u32 = 0;
    var lines_instr: [][]u8 = try allocator.alloc([]u8, lines_instr_cap);
    defer allocator.free(lines_instr);

    var has_collected_crates = false;

    var read_lines: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&lines_buf[read_lines], '\n')) |line| {
        if (!has_collected_crates) {
            if (lines_crates_len == lines_crates_cap) {
                lines_crates_cap *= 2;
                lines_crates = try allocator.realloc(lines_crates, lines_crates_cap);
            }
            if (strEq(line, "")) {
                has_collected_crates = true;
            } else {
                lines_crates[lines_crates_len] = line;
                lines_crates_len += 1;
            }
        } else {
            if (lines_instr_len == lines_instr_cap) {
                lines_instr_cap *= 2;
                lines_instr = try allocator.realloc(lines_instr, lines_instr_cap);
            }
            lines_instr[lines_instr_len] = line;
            lines_instr_len += 1;
        }

        read_lines += 1;
    }

    var stacks = try parseCrates(allocator, lines_crates, lines_crates_len);
    for (stacks) |*stack| {
        try reverseStack(allocator, stack);
    }

    var instructions = try parseInstructions(allocator, lines_instr, lines_instr_len);

    const out = CraneInstr{
        .stacks = stacks,
        .instructions = instructions,
    };

    return out;
}

/// Collects all the stacks
fn parseCrates(allocator: mem.Allocator, lines: [][]u8, len: u32) ![]Stack {
    const last_line = lines[len - 1];
    const crates_len = collectCratesPosAmt(last_line);

    var stacks: []Stack = try allocator.alloc(Stack, crates_len);

    var crates_cap: u32 = 128; // There can only be a total of 128 crates due to this

    var i: u32 = 0;
    while (i < crates_len) : (i += 1) {
        stacks[i].crates = try allocator.alloc(Crate, crates_cap);
        stacks[i].crates_cap = crates_cap;
        stacks[i].crates_len = 0;
    }

    var lines_idx: u32 = 0;
    // < len - 1, because the last line contains thenumbers of the stacks
    while (lines_idx < len - 1) : (lines_idx += 1) {
        i = 0;
        while (i < crates_len) : (i += 1) {
            var crate_name = lines[lines_idx][(i * 4) + 1];
            if (crate_name != ' ') {
                stacks[i].crates[stacks[i].crates_len].name = crate_name;
                stacks[i].crates_len += 1;
            }
        }
    }
    return stacks;
}

/// Collect the amount of positions a crate can be in
fn collectCratesPosAmt(line: []u8) u32 {
    var len: u32 = 0;
    for (line) |char| {
        if (char != ' ' and char != '\n') {
            len += 1;
        }
    }
    return len;
}

/// Compare two strings
fn strEq(lhs: []const u8, rhs: []const u8) bool {
    if (lhs.len != rhs.len) return false;
    var i: u32 = 0;
    while (i < lhs.len) : (i += 1) {
        if (lhs[i] != rhs[i]) return false;
    }
    return true;
}

fn parseInstructions(allocator: mem.Allocator, lines: [][]u8, len: u32) ![]Instruction {
    const InstrType = enum { Move, From, To, None };

    var instructions = try allocator.alloc(Instruction, len);
    var char_buf: [6]u8 = undefined;
    var char_idx: u32 = 0;
    var instr_t = InstrType.None;

    var lines_idx: u32 = 0;
    while (lines_idx < len) : (lines_idx += 1) {
        const line = lines[lines_idx];

        var line_idx: u32 = 0;
        while (line_idx < line.len) : (line_idx += 1) {
            const char = line[line_idx];
            char_buf[char_idx] = char;

            switch (instr_t) {
                .Move => {
                    if (char == ' ') {
                        var int = try std.fmt.parseInt(u32, char_buf[0..char_idx], 10);
                        instr_t = .None;
                        instructions[lines_idx].amt = int;
                        char_idx = 0;
                    } else {
                        char_idx += 1;
                    }
                },
                .From => {
                    if (char == ' ') {
                        var int = try std.fmt.parseInt(u32, char_buf[0..char_idx], 10);
                        instr_t = .None;
                        instructions[lines_idx].from = int;
                        char_idx = 0;
                    } else {
                        char_idx += 1;
                    }
                },
                .To => {
                    if (line_idx == line.len - 1) {
                        var int = try std.fmt.parseInt(u32, char_buf[0..(char_idx + 1)], 10);
                        instr_t = .None;
                        instructions[lines_idx].to = int;
                        char_idx = 0;
                    } else {
                        char_idx += 1;
                    }
                },
                .None => {
                    if (strEq(char_buf[0..(char_idx)], "move")) {
                        instr_t = .Move;
                        char_idx = 0;
                    } else if (strEq(char_buf[0..(char_idx)], "from")) {
                        instr_t = .From;
                        char_idx = 0;
                    } else if (strEq(char_buf[0..(char_idx)], "to")) {
                        instr_t = .To;
                        char_idx = 0;
                    } else {
                        char_idx += 1;
                    }
                },
            }
        }
    }

    return instructions;
}
