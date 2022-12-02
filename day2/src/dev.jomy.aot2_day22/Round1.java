package dev.jomy.aot2_day2;

public class Round1 {
    public MoveType opponent;
    public MoveType santa;

    public Round1(Character opponent, Character santa) {
        this.opponent = MoveType.from(opponent).get(); // no isPresent check because should never be optional with input
        this.santa = MoveType.from(santa).get();
    }

    public Round1(MoveType opponent, MoveType santa) {
        this.opponent = opponent;
        this.santa = santa;
    }
}
