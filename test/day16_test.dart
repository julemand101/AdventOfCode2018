// --- Day 16: Chronal Classification ---
// https://adventofcode.com/2018/day/16

import 'dart:io';
import 'package:test/test.dart';
import 'package:AdventOfCode2018/day16.dart';

const String dataFilePath = 'test/data/day16.txt';

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(
          solveA(['Before: [3, 2, 1, 1]', '9 2 1 2', 'After:  [3, 2, 2, 1]']),
          equals(1));
    });
    test('Solution', () {
      expect(solveA(File(dataFilePath).readAsLinesSync()), equals(567));
    });
  });
}
