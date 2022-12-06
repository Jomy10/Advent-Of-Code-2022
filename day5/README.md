# Day 5

Day 5 has me coding in another low-level, alloc/free language: **Zig**

```zig
const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
  try stdout.print("Hello world\n", .{});
}
```

The only thing I can say is that I've had enough of low-level programming languges
in Advent of Code. As input gets more complicated, it's nice to have some more
string methods in the standard library. Not many low-level languages remain on the
list though. I'm rooting for Ruby tomorrow because I'm starting to get behind on the
puzzles.
