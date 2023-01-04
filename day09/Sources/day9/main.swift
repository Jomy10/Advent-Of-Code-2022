import Foundation

struct Pos {
	var x: Int
	var y: Int
}

extension Pos: Hashable {}

extension Pos {
	static func +(lhs: Pos, rhs: Pos) -> Pos {
		return Pos(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
	
	static func +=(lhs: inout Pos, rhs: Pos) {
		lhs = lhs + rhs
	}
	
	static func-(lhs: Pos, rhs: Pos) -> Pos {
		return Pos(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
	}
	
	static func-=(lhs: inout Pos, rhs: Pos) {
		lhs = lhs + rhs
	}
	
	static func /(lhs: Pos, rhs: Pos) -> Pos {
		return Pos(x: lhs.x / rhs.y, y: lhs.y / rhs.y)
	}
	
	static func /=(lhs: inout Pos, rhs: Pos) {
		lhs = lhs / rhs
	}
}

let inputFile = "input.txt"

var contents = try String(contentsOfFile: inputFile, encoding: .utf8)

/// Returns the amount of unique positions the tail of the rope visits
func simulateRope(ropeSize: Int) -> Int {
	let startingPosition = Pos(x: 0, y: 0)
	var visitedPositions = Set<Pos>()
	visitedPositions.insert(startingPosition)

	var rope = Array<Pos>(repeating: startingPosition, count: ropeSize)

	contents.enumerateLines { line, _ in
		let instruction = line.split(separator: " ")

		let headDir: Pos
		switch (instruction[0]) {
			case "R":
				headDir = Pos(x: 1, y: 0)
			case "L":
				headDir = Pos(x: -1, y: 0)
			case "U":
				headDir = Pos(x: 0, y: -1)
			case "D":
				headDir = Pos(x: 0, y: 1)
			default:
				print("Invalid instuction \(instruction[0])")
				exit(1)
		}

		for _ in 0..<Int(instruction[1])! {
			rope[rope.count - 1] += headDir

			for i in (0..<(rope.count - 1)).reversed() {
				let diff = rope[i + 1] - rope[i]

				if (abs(diff.x) > 1 || abs(diff.y) > 1) {
					// Move rope at position i to rope at position i + 1
					rope[i] = Pos(
						x: rope[i].x + ((diff.x == 0) ? diff.x : diff.x / abs(diff.x)),
						y: rope[i].y + ((diff.y == 0) ? diff.y : diff.y / abs(diff.y))
					)
				}
			}

			// Insert tail's position to visited positions
			visitedPositions.insert(rope[0])
		}
	}

	return visitedPositions.count
}

print("Part 1: \(simulateRope(ropeSize: 2))")

print("Part 2: \(simulateRope(ropeSize: 10))")
