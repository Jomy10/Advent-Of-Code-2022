#include "input.h"

// Same as in day 4
char* readFile(char* fileName) {
  FILE* file;
  int inputCap = 128;
  int inputLen = 0;
  char* input = malloc(inputCap);

  file = fopen(fileName, "r");

  if (file == NULL) {
    return NULL;
  }

  while (!feof(file)) {
    if (inputLen == inputCap) {
      inputCap *= 2;
      input = realloc(input, inputCap);
    }

    input[inputLen++] = fgetc(file);
  }

  fclose(file);

  return input;
}

// Split a string based on a delimiter
// modifies the original string
struct SplitResult split(char* str, char delimiter) {
  int arrCap = 10;
  int arrLen = 0;
  int startIdx = 0;
  char** arr = malloc(sizeof(char*) * arrCap);
  int len = strlen(str);
  for (int i = 0; i < len; i++) {
    if (str[i] == delimiter) {
      if (arrLen == arrCap) {
        arrCap *= 2;
        arr = realloc(arr, sizeof(char*) * arrCap);
      }

      arr[arrLen++] = str + startIdx;
        str[i] = '\0';
      startIdx = i + 1;
    }
  }

  return (struct SplitResult) { arr, arrLen };
}
