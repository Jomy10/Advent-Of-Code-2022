<?php

// Read input file
$inputFilePath = "input.txt";
$inputFile = fopen($inputFilePath, "r") or die("Unable to open file!");
$input = fread($inputFile, filesize($inputFilePath));
fclose($inputFile);
$lines = explode("\n", $input);

// Registers
$X = 1;

// Currently executing instruction
$instr = NULL;

class Instruction {
  public $type;
  // Data of the instruction (e.g. `addx 3` -> data = 3)
  public $data;
  // The number of cycles this operation has been running for
  public $cycles;

  function __construct($type, $data = null) {
    $this->type = $type;
    $this->data = $data;
    $this->cycles = 0;
  }

  function __toString() {
    return "Instruction: " . $this->type->toString() . ", " . $this->data . ", " . $this->cycles;
  }

  public function nextCycle() {
    $this->cycles++;
  }
}

enum InstructionType {
  case noop;
  case addx;

  function toString() {
    return match ($this) {
      InstructionType::noop => "noop",
      InstructionType::addx => "addx",
    };
  }

  public static function fromString($str) {
    return match ($str) {
      "noop" => self::noop,
      "addx" => self::addx,
    };
  }
}

class CRT {
  public $screen;

  function __construct() {
    $this->screen = new SplFixedArray(6);

    $i = 0;
    while ($i < 6) {
      $this->screen[$i] = new SplFixedArray(40);

      $j = 0;
      while ($j < 40) {
        $this->screen[$i][$j] = ".";
        $j++;
      }

      $i++;
    }
  }

  function draw($x, $y) {
    $this->screen[$y][$x] = "#";
  }

  function show() {
    foreach ($this->screen as $line) {
      foreach ($line as $pixel) {
        echo $pixel;
      }
      echo "\n";
    }
  }
}

// CPU Cycles
$lines = array_filter($lines); // Filter empty array elements ("")
$linePtr = 0;
$lineLen = count($lines);

$cycleCount = 0;
$totalSignalStrength = 0;

$crt = new CRT();
$crtPtr = 0;

while (true) {
  if ($linePtr == $lineLen && $instr == NULL) {
    // program finished
    break;
  }
  $cycleCount += 1;
  
  // Assign new instruction if none is running
  if ($instr == NULL) {
    $line = $lines[$linePtr];
    $instruction = explode(" ", $line);
    $instructionType = InstructionType::fromString($instruction[0]);

    $instr = match ($instructionType) {
      InstructionType::noop => new Instruction($instructionType),
      InstructionType::addx => new Instruction($instructionType, intval($instruction[1])),
    };

    $linePtr += 1;
  }

  // Part 1
  // interesting signal strengths
  if (($cycleCount - 20) % 40 == 0 && $cycleCount <= 220) {
    // Part 1
    $signalStrength = $cycleCount * $X;
    $totalSignalStrength += $signalStrength;
  }

  // Part 2
  $crtRow = floor($crtPtr / 40);
  $crtCol = $crtPtr % 40; // index in the row

  if ($crtCol == $X || $crtCol == $X - 1 || $crtCol == $X + 1) {
    $crt->draw($crtCol, $crtRow);
  }

  $crtPtr += 1;
  // Increase instruction's number of cycles it has been running for
  $instr->nextCycle();

  // Finish instruction
  switch ($instr->type) {
    case InstructionType::noop:
      if ($instr->cycles == 1) {
        // Clear instruction (finished)
        $instr = NULL;
      }
      break;
    case InstructionType::addx:
      if ($instr->cycles == 2) {
        $X += $instr->data;
        $instr = NULL;
      }
      break;
  }
}

echo "Part 1: $totalSignalStrength\n";

echo "== Part 2 ==\n";
$crt->show();

?>
