package dev.jomy.aot2_day2;

public class Round2 {
    public MoveType opponent;
    public RoundStatus santaShould;

    public Round2(Character opponent, Character santa) {
        this.opponent = MoveType.from(opponent).get();
        this.santaShould = RoundStatus.from(santa);
    }

    public Round1 to1() {
        return new Round1(this.opponent, this.opponent.getOtherFromStatus(this.santaShould));
    }
}
