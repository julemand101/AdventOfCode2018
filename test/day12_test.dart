// --- Day 12: Subterranean Sustainability ---
// https://adventofcode.com/2018/day/12

import 'dart:io';
import 'package:test/test.dart';
import 'package:AdventOfCode2018/day12.dart';

const String dataFilePath = 'test/data/day12.txt';

const List<String> example = [
  'initial state: #..#.#..##......###...###',
  '',
  '...## => #',
  '..#.. => #',
  '.#... => #',
  '.#.#. => #',
  '.#.## => #',
  '.##.. => #',
  '.#### => #',
  '#.#.# => #',
  '#.### => #',
  '##.#. => #',
  '##.## => #',
  '###.. => #',
  '###.# => #',
  '####. => #'
];

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(solveA(example), equals(325));
    });
    test('Solution', () {
      expect(solveA(File(dataFilePath).readAsLinesSync()), equals(2840));
    });
  });
}
