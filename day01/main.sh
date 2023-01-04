#!/usr/bin/env zsh

# Total calories per elve
total_calories=()

current_elve_cals=0

cat "$1" | while read line; do
  current_elve_cals=$(($line + $current_elve_cals))

  if [[ $line == "" ]]; then
    total_calories+=$current_elve_cals
    current_elve_cals=0
  fi
done

# Add the last one
total_calories+=$current_elve_cals

# Sort O = reverse order, n = numerical sort (zsh only)
sorted=("${(@nO)total_calories}")

# Part 1
printf 'Part 1: %s\n' "${sorted[1]}"

# Part 2
printf 'Part 2: %s\n' "${$(($sorted[1] + $sorted[2] + $sorted[3]))}"
