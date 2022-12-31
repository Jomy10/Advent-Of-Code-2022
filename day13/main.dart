import 'dart:io';
import 'parser.dart';
import "part1.dart";
import "part2.dart";

void main() {
  var input = File("input.txt").readAsStringSync();
  var pairs = parse(input);

  var indices = get_equal_pair_indices(pairs);
  var part1 = indices.reduce((a, b) => a + b);

  print("part1: $part1");

  print("part2: ${part2(pairs)}");
}
