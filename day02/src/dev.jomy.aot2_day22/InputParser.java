package dev.jomy.aot2_day2;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.ArrayList;

public class InputParser {
    public static class RoundCharacters {
        public Character one;
        public Character two;
        public RoundCharacters(Character one, Character two) {
            this.one = one; this.two = two;
        }
    }

    public static List<RoundCharacters> getRoundChars(String fileName) throws IOException {
        Path filePath = Path.of(fileName);
        String content = Files.readString(filePath);
        content = content.strip();
        String[] lines = content.split("\n");
        List<RoundCharacters> rounds = new ArrayList<>();
        for (String line : lines) {
            String[] split = line.split(" ");
            rounds.add(new RoundCharacters(split[0].charAt(0), split[1].charAt(0)));
        }
        return rounds;
    }

    public static List<Round1> getRounds1(List<RoundCharacters> rc) {
        List<Round1> rounds = new ArrayList<>();
        for (RoundCharacters r : rc) {
            rounds.add(new Round1(r.one, r.two));
        }
        return rounds;
    }

    public static List<Round2> getRounds2(List<RoundCharacters> rc) {
        List<Round2> rounds = new ArrayList<>();
        for (RoundCharacters r : rc) {
            rounds.add(new Round2(r.one, r.two));
        }
        return rounds;
    }
}
