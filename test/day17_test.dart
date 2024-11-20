// --- Day 17: Reservoir Research ---
// https://adventofcode.com/2018/day/17

import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_of_code_2018/day17.dart';

const String dataFilePath = 'test/data/day17.txt';

const example = [
  'x=495, y=2..7',
  'y=7, x=495..501',
  'x=501, y=3..7',
  'x=498, y=2..4',
  'x=506, y=1..2',
  'x=498, y=10..13',
  'x=504, y=10..13',
  'y=13, x=498..504'
];

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(solveA(example), equals(57));
    });
    test('Solution', () {
      expect(solveA(File(dataFilePath).readAsLinesSync()), equals(30635));
    });
  });
  group('Part Two', () {
    test('Example 1', () {
      expect(solveB(example), equals(29));
    });
    test('Solution', () {
      expect(solveB(File(dataFilePath).readAsLinesSync()), equals(25094));
    });
  });
}
