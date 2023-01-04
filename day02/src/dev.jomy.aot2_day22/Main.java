package dev.jomy.aot2_day2;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {
        String inputPath = "../input.txt";
    
        // Parse input
        List<InputParser.RoundCharacters> rounds;
        try {
            rounds = InputParser.getRoundChars(inputPath);
        } catch (IOException e) {
            e.printStackTrace();
            return;
        }
        List<Round1> rounds1 = InputParser.getRounds1(rounds);
        List<Round2> rounds2 = InputParser.getRounds2(rounds);

        // Part 1
        ScoreCounter sc = new ScoreCounter(rounds1.toArray(new Round1[0]));
        int totalScorePart1 = sc.calculateScoreForSanta();

        System.out.printf("Part 1: %s\n", totalScorePart1);

        // Part 2
        List<Round1> rounds2_1 = new ArrayList<>();
        for (Round2 round2 : rounds2) {
            rounds2_1.add(round2.to1());
        }

        ScoreCounter sc2 = new ScoreCounter(rounds2_1.toArray(new Round1[0]));
        int totalScorePart2 = sc2.calculateScoreForSanta();

        System.out.printf("Part 2: %s\n", totalScorePart2);
    }
}
