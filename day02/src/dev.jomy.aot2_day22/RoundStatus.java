package dev.jomy.aot2_day2;

public enum RoundStatus{
    WIN, DRAW, LOSE;

    public static RoundStatus from(Character c) {
        return switch (c) {
            case 'X' -> LOSE;
            case 'Y' -> DRAW;
            case 'Z' -> WIN;
        };
    }
}