// --- Day 3: No Matter How You Slice It ---
// https://adventofcode.com/2018/day/3

import 'dart:io';
import 'package:test/test.dart';
import 'package:AdventOfCode2018/day03.dart';

const String dataFilePath = 'test/data/day03.txt';

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(solveA(['#1 @ 1,3: 4x4', '#2 @ 3,1: 4x4', '#3 @ 5,5: 2x2']),
          equals(4));
    });
    test('Solution', () {
      expect(solveA(File(dataFilePath).readAsLinesSync()), equals(111935));
    });
  });

  group('Part Two', () {
    test('Example 1', () {
      expect(solveB(['#1 @ 1,3: 4x4', '#2 @ 3,1: 4x4', '#3 @ 5,5: 2x2']),
          equals(3));
    });
    test('Solution', () {
      expect(solveB(File(dataFilePath).readAsLinesSync()), equals(650));
    });
  });
}
