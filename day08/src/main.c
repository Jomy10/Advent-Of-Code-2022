#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>

#include "input.h"
#include "main.h"

int main() {
  char* input = readFile("input.txt");
  struct SplitResult sResult = split(input, '\n');
  char** lines = sResult.lines;
  int linesLen = sResult.size;
  int lineLen = strlen(sResult.lines[0]);

  int totalVisible = 0;
  for (int y = 0; y < linesLen; y++) {
    if (y == 0 || y == linesLen - 1) {
      totalVisible += linesLen;
      continue;
    }
    
    for (int x = 0; x < lineLen; x++) {
      if (x == 0 || x == lineLen - 1) {
        totalVisible++;
        continue;
      }

      // < only internal trees
      if (isVisible(lines, x, y, lineLen, linesLen)) {
        totalVisible++;
      }
    }
  }

  printf("Part 1: %d\n", totalVisible);

  int highestScenicScore = 0;
  for (int y = 0; y < linesLen; y++) {
    for (int x = 0; x < lineLen; x++) {
      int currentScenicScore = scenicScore(lines, x, y, lineLen, linesLen);
      if (currentScenicScore > highestScenicScore) {
        highestScenicScore = currentScenicScore;
      }
    }
  }

  printf("Part 2: %d\n", highestScenicScore);

  free(input);

  return 0;
}

// Returns whether a tree at position (`x`, `y`) is visible
bool isVisible(char** trees, int x, int y, int xLen, int yLen) {
  uint8_t currentTree = trees[y][x] - '0';

  // Check row left of tree
  bool visible = true;
  for (int xIdx = 0; xIdx < x; xIdx++) {
    if (currentTree <= trees[y][xIdx] - '0') {
      visible = false;
      break;
    }
  }

  if (visible) return true;

  // Check row right of tree
  visible = true;
  for (int xIdx = x + 1; xIdx < xLen; xIdx++) {
    if (currentTree <= trees[y][xIdx] - '0') {
      visible = false;
      break;
    }
  }

  if (visible) return true;

  // Check column top
  visible = true;
  for (int yIdx = 0; yIdx < y; yIdx++) {
    if (currentTree <= trees[yIdx][x] - '0') {
      visible = false;
      break;
    }
  }

  if (visible) return true;

  visible = true;
  for (int yIdx = y + 1; yIdx < yLen; yIdx++) {
    if (currentTree <= trees[yIdx][x] - '0') {
      visible = false;
      break;
    }
  }

  if (visible) return true;

  return false;
}

// Calculate a tree's scenic score
int scenicScore(char** trees, int x, int y, int xLen, int yLen) {
  uint8_t currentTree = trees[y][x] - '0';
  
  // Left
  int leftScore = 0;
  for (int xIdx = x - 1; xIdx >= 0; xIdx--) {
    leftScore += 1;
    if (currentTree <= trees[y][xIdx] - '0') {
      break;
    }
  }

  // Right
  int rightScore = 0;
  for (int xIdx = x + 1; xIdx < xLen; xIdx++) {
    rightScore += 1;
    if (currentTree <= trees[y][xIdx] - '0') {
      break;
    }
  }

  // Up
  int upScore = 0;
  for (int yIdx = y - 1; yIdx >= 0; yIdx--) {
    upScore += 1;
    if (currentTree <= trees[yIdx][x] - '0') {
      break;
    }
  }

  // Down
  int downScore = 0;
  for (int yIdx = y + 1; yIdx < yLen; yIdx++) {
    downScore += 1;
    if (currentTree <= trees[yIdx][x] - '0') {
      break;
    }
  }

  return leftScore * rightScore * upScore * downScore;
}
