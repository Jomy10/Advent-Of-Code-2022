#ifndef AOC22_DAY8_READ_H
#define AOC22_DAY8_READ_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct SplitResult {
  char** lines;
  int size;
};

char* readFile(char* fileName);
struct SplitResult split(char* str, char delimiter);

#endif
