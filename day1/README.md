# Day 1

It's finally here, Advent of Code! This year's timing isn't very great, because
today is also the first day I start working, so spare time is going to be sparse.

As an early christmas gift to myself, and because the first day will be an easy puzzle,
I will not let a randomize decide the language for the first day. Instead, I'll
get **ShellScript** done immediately.

## Solution

We're looping over the the lines of the input file. Reading the file is just
using cat, which is probably the biggest bonus of solving this in ShellScript.
In the loop, we add the total calories of each elve to an array.

Then the array gets sorted. In Zsh, which is the shell I use, there is built-in
support for sorting array.

```zsh
sorted=("${(@nO)array}")
```

The `n` flag sorts the array numerically, and the `O` flag puts them in reverse
order. This means our solution will be the first element of the array.

For part 1, we just print out the first element and for part 2, we print out the
sum of the first 3 elements.

And that is day 1!

On to the next day, I'm excited to see what tomorrow's puzzle will bring, and
mostly what the language will be.

## Running

`./main.sh [FILE]`

- `example.txt` is the example input from Advent of Code
- `input.txt` is my puzzle input
