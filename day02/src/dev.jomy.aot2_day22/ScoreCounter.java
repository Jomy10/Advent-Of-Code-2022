package dev.jomy.aot2_day2;

public class ScoreCounter {
    Round1[] rounds;

    public ScoreCounter(Round1[] rounds) {
        this.rounds = rounds;
    }

    public int calculateScoreForSanta() {
        int total = 0;
        for (Round1 round : this.rounds) {
            total += round.santa.scoreValue();
            switch (round.santa.winsFrom(round.opponent)) {
                case WIN:
                    total += 6;
                    break;
                case DRAW:
                    total += 3;
                    break;
                case LOSE:
                    break;
            }
        }
        return total;
    }
}
