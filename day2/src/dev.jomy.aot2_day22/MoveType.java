package dev.jomy.aot2_day2;

import java.util.Optional;

public enum MoveType {
    ROCK, PAPER, SCISSORS;

    public static Optional<MoveType> from(Character move) {
        return switch (move) {
            case 'A', 'X' -> Optional.of(MoveType.ROCK);
            case 'B', 'Y' -> Optional.of(MoveType.PAPER);
            case 'C', 'Z' -> Optional.of(MoveType.SCISSORS);
            default -> Optional.empty();
        };
    }

    /** The amount added to the score when you choose this move */
    public int scoreValue() {
        return switch (this) {
            case ROCK -> 1;
            case PAPER -> 2;
            case SCISSORS -> 3;
        };
    }

    public RoundStatus winsFrom(MoveType other) {
        return switch (this) {
            case ROCK -> switch (other) {
                case ROCK -> RoundStatus.DRAW;
                case PAPER -> RoundStatus.LOSE;
                case SCISSORS -> RoundStatus.WIN;
            };
            case PAPER -> switch (other) {
                case ROCK -> RoundStatus.WIN;
                case PAPER -> RoundStatus.DRAW;
                case SCISSORS -> RoundStatus.LOSE;
            };
            case SCISSORS -> switch (other) {
                case ROCK -> RoundStatus.LOSE;
                case PAPER -> RoundStatus.WIN;
                case SCISSORS -> RoundStatus.DRAW;
            };
        };
    }

    public MoveType getOtherFromStatus(RoundStatus status) {
        return switch (status) {
            case WIN ->
                    // Return the MoveType that will win from this
                    switch (this) {
                        case ROCK -> PAPER;
                        case PAPER -> SCISSORS;
                        case SCISSORS -> ROCK;
                    };
            case DRAW -> this;
            case LOSE -> switch (this) {
                case ROCK -> SCISSORS;
                case PAPER -> ROCK;
                case SCISSORS -> PAPER;
            };
        };
    }
}
