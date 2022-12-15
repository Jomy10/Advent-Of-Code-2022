import * as fs from 'fs';

type Pos = {
  x: number,
  y: number,
};

type Line = {
  start: Pos,
  end  : Pos,
};

function posEq(pos: Pos, other: Pos) {
  return pos.x == other.x && pos.y == other.y;
}

// assumes integers never go over 16bits
class PosSet {
  set: Set<number>;

  constructor() {
    this.set = new Set();
  }
  
  add(o: Pos) {
    this.set.add(o.x << 16 | o.y);
  }

  has(o: Pos): boolean {
    return this.set.has(o.x << 16 | o.y);
  }

  intoIter(): PosSetIter {
    return new PosSetIter(this);
  }

  /** Clone this object */
  clone(): PosSet {
    const blocked2 = new PosSet();
    let iter = this.intoIter();
    let next = iter.next();
    while (next != null) {
      blocked2.add(next);
      
      next = iter.next();
    }
    return blocked2;
  }
}

const yMask = (() => {
  let mask = 0;
  for (let i = 0; i < 16; i++) {
    mask |= (1 << i);
  }
  return mask;
})();
const xMask =(() => {
  let mask = 0;
  for (let i = 0; i < 16; i++) {
    mask |= (1 << (i + 16));
  }
  return mask;
})();
class PosSetIter {
  itererator;

  constructor(set: PosSet) {
    this.itererator = set.set[Symbol.iterator]();
  }

  next(): Pos | null {
    let n = this.itererator.next();
    if (n.done) {
      return null;
    } else {
      let x = (n.value & xMask) >> 16;
      let y = n.value & yMask;
      return { x: x, y: y };
    }
  }
}

function parseRockFormations(inputFile: string): PosSet {
  const contents = fs.readFileSync(inputFile, 'utf8');
  const lines = contents.split("\n").filter((v: string) => v != "");
  const rockPositions: Pos[][] = lines
    .map((v: string) => v
      .split(" -> ")
      .map(v => v
        .split(",")
        .map((i: string) => parseInt(i))
      )
      .map(v => {
        const pos: Pos = {x: v[0], y: v[1] };
        return pos;
      })
    );

  let rockSet = new PosSet();
  rockPositions.forEach((pos: Pos[]) => {
    let lines: Line[] = [];
    for (let i = 0; i < pos.length - 1; i++) {
      lines.push({
        start: pos[i],
        end: pos[i+1],
      });
    }

    for (let line of lines) {
      if (line.end.x == line.start.x) {
        let x = line.start.x;
        let startY: number;
        let endY: number;
        if (line.start.y < line.end.y) {
          startY = line.start.y;
          endY = line.end.y;
        } else {
          startY = line.end.y;
          endY = line.start.y;
        }
        for (let y = startY; y <= endY; y++) {
          rockSet.add({x: x, y: y})
        }
      } else if (line.end.y == line.end.y) {
        let y = line.start.y;
        let startX: number;
        let endX: number;
        if (line.start.x < line.end.x) {
          startX = line.start.x;
          endX = line.end.x;
        } else {
          startX = line.end.x;
          endX = line.start.x;
        }
        for (let x = startX; x <= endX; x++) {
          rockSet.add({x: x, y: y});
        }
      }
    }
  });

  return rockSet;
}

/** @param maxY {number | undefined} opitional floor */
function isTileBlocked(rocks: PosSet, pos: Pos, maxY: number | undefined) {
  return pos.y == maxY || rocks.has(pos);
}

/**
 * @param rocks {PosSet} the blocked positions
 * @param _sandPos {Pos} the curret position of the particle
 * @param maxY {number | undefined} opitional floor
 * @returns {Pos} the new position of the sand
 */
function sandStep(rocks: PosSet, _sandPos: Pos, maxY: number | undefined): Pos {
  let sandPos = Object.assign({}, _sandPos);
  // Down is y += 1
  // left is x -= 1
  if (!isTileBlocked(rocks, { x: sandPos.x, y: sandPos.y + 1 }, maxY)) {
    sandPos.y += 1;
    return sandPos;
  } else if (!isTileBlocked(rocks, { x: sandPos.x - 1, y: sandPos.y + 1}, maxY)) {
    sandPos.x -= 1;
    sandPos.y += 1;
    return sandPos;
  } else if (!isTileBlocked(rocks, { x: sandPos.x + 1 , y: sandPos.y + 1 }, maxY)) {
    sandPos.x += 1;
    sandPos.y += 1;
    return sandPos;
  } else {
    return sandPos;
  }
}

function lowestRockY(form: PosSet): number {
  let lowestY: number = 0;
  let iter = form.intoIter();
  let rock = iter.next();
  while (rock != null) {
    if (rock!.y > lowestY) lowestY = rock!.y;
    rock = iter.next();
  }
  return lowestY;
}

/** Part 1
 * @returns the amount of sand particles that stay on the platform
 */
function part1(startPos: Pos, blocked: PosSet, lowestRockPosY: number): number {
  let unitsOfSandFallen = 0;
  outer: while (true) {
    // Particle
    let particlePos = startPos;
    let newPos;
    unitsOfSandFallen += 1;
    inner: while (true) {
      newPos = sandStep(blocked, particlePos, undefined);

      // Check if particle is in void
      if (lowestRockPosY < newPos.y) {
        break outer;
      }

      // Check if particle has rested
      if (posEq(newPos, particlePos)) break inner;
      particlePos = newPos;

    }

    // Particle has rested
    blocked.add(particlePos);
  }

  // `- 1` because the last particle fell into the void
  return unitsOfSandFallen - 1;
}

function part2(startPos: Pos, blocked: PosSet, lowestRockPosY: number): number {
  let floor = lowestRockPosY + 2;
  let unitsOfSandFallen = 0;
  outer: while (true) {
    let particlePos = startPos;
    let newPos;
    unitsOfSandFallen += 1;
    inner: while (true) {
      newPos = sandStep(blocked, particlePos, floor);

      if (posEq(newPos, particlePos)) break inner;
      particlePos = newPos;
    }

    if (posEq(particlePos, startPos)) break outer;

    blocked.add(particlePos);
  }

  return unitsOfSandFallen;
}

function main() {
  const startPos: Pos = { x: 500, y: 0 };
  const blocked = parseRockFormations("input.txt");
  const lowestRockPosY = lowestRockY(blocked);
  const blocked2 = blocked.clone();

  console.log(`Part 1: ${part1(startPos, blocked, lowestRockPosY)}`);
  console.log(`Part 2: ${part2(startPos, blocked2, lowestRockPosY)}`);
}

main();
