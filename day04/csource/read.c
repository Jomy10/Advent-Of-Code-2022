#include <stdlib.h>
#include <stdio.h>

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
