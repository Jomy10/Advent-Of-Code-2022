module day4;
import std::io;

// Reading files in C3 didn't really work (or I couldn't get it to work), so I'm importing a C function
extern fn char* readFile(char*);

// C std
extern fn void exit(int);
extern fn double pow(double, double);
extern fn isz strlen(char*);
extern fn int atoi(char*);

fn int main(char[][] args)
{
    char* input = readFile("input.txt");
    if (input == (char*) 0) {
        exit(1);
    }
    defer free(input);

    Pairs pairs = parseInput(input);
    defer free(pairs.pairs);

    // Printing parsed input
    // for (int i = 0; i < pairs.len; i++) {
    // 	Pair pair = pairs.pairs[i];
    // 	io::printf("Pair { %d..%d, %d..%d }\n", pair.one.start, pair.one.end, pair.two.start, pair.two.end);
    // }

    // Part 1
    int totalOverlappingRanges = 0;
    for (int i = 0; i < pairs.len; i++) {
        if (pairContains(pairs.pairs[i]) > 0) {
            totalOverlappingRanges += 1;
        }
    }

    io::printf("Part 1: %d\n", totalOverlappingRanges);

    // Part 2
    int amtOverlapping = 0;
    
    for (int i = 0; i < pairs.len; i++) {
        if (pairOverlap(pairs.pairs[i])) {
            amtOverlapping++;
        }
    }

    io::printf("Part 2: %d\n", amtOverlapping);
    
    return 0;
}

struct Range {
    int start;
    int end;
}

struct Pair {
    Range one;
    Range two;
}

// Returns whether a pair's range containst the other range:
// 0 for no fully contains
// 1 for range 1 fully contains range 2
// 2 for range 2 fully contains range 1
// 3 if both ranges are equal
fn int pairContains(Pair pair) {
    return rangeContains(pair.one, pair.two);
}

// Full overlap
fn int rangeContains(Range range1, Range range2) {
    if (range1.start == range2.start && range1.end == range2.end) {
        return 3;
    } else if (range1.start <= range2.start && range1.end >= range2.end) {
        return 1;
    } else if (range2.start <= range1.start && range2.end >= range1.end) {
        return 2;
    } else {
        return 0;
    }
}

// Returns whether the two ranges of a pair have any overlap
fn bool pairOverlap(Pair pair) {
    return rangeOverlap(pair.one, pair.two);
}

fn bool rangeOverlap(Range range1, Range range2) {
    return range1.start >= range2.start && range1.start <= range2.end
        || range1.end >= range2.start && range1.end <= range2.end
        || range2.start >= range1.start && range2.start <= range1.end
        || range2.end >= range1.start && range2.end <= range1.end;
}

struct Pairs {
    Pair* pairs;
    int len;
}

fn Pairs parseInput(char* input) {
    int pairsCap = 128;
    int pairsLen = 0;
    Pair* pairs = malloc(Pair.sizeof * pairsCap);
    bool atPairOne = true;
    bool atStart = true;

    int numberLen = 0;
    char* numberBuf = malloc(50);	
    
    for (int i = 0; i < strlen(input); i++) {
        char c = input[i];

        if (c != '-' && c != ',' && c != '\n') {
            // Collect next integer
            numberBuf[numberLen++] = c;
            continue;
        }

        numberBuf[numberLen] = '\0';
        int parsedNumber = atoi(numberBuf);
        numberLen = 0;

        if (atPairOne) {
            if (atStart) {
                pairs[pairsLen].one.start = parsedNumber;
            } else {
                pairs[pairsLen].one.end = parsedNumber;
            }
        } else {
            if (atStart) {
                pairs[pairsLen].two.start = parsedNumber;
            } else {
                pairs[pairsLen].two.end = parsedNumber;
            }
        }
        
        if (c == '-') {
            atStart = false;
        } else if (c == ',') {
            atStart = true;
            atPairOne = false;
        } else if (c == '\n') {
            atStart = true;
            atPairOne = true;
            pairsLen++;
            if (pairsLen == pairsCap) {
                pairsCap *= 2;
                pairs = mem::realloc(pairs, Pair.sizeof * pairsCap);
            }
        }
    }

    free(numberBuf);

    return Pairs { pairs, pairsLen };
}
