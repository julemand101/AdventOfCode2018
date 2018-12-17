// --- Day 13: Mine Cart Madness ---
// https://adventofcode.com/2018/day/13

import 'dart:io';
import 'package:test/test.dart';
import 'package:AdventOfCode2018/day13.dart';

const String dataFilePath = 'test/data/day13.txt';

const List<String> example = [
  r'/->-\',
  r'|   |  /----\',
  r'| /-+--+-\  |',
  r'| | |  | v  |',
  r'\-+-/  \-+--/',
  r'  \------/'
];

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(solveA(example), equals('7,3'));
    });
    test('Solution', () {
      expect(solveA(File(dataFilePath).readAsLinesSync()), equals('26,92'));
    });
  });
}
