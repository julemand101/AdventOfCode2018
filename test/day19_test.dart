// --- Day 19: Go With The Flow ---
// https://adventofcode.com/2018/day/19

import 'package:test/test.dart';
import 'package:advent_of_code_2018/day19.dart';

const example = [
  '#ip 0',
  'seti 5 0 1',
  'seti 6 0 2',
  'addi 0 1 0',
  'addr 1 2 3',
  'setr 1 0 0',
  'seti 8 0 4',
  'seti 9 0 5',
];

const input = [
  '#ip 5',
  'addi 5 16 5',
  'seti 1 2 2',
  'seti 1 0 4',
  'mulr 2 4 3',
  'eqrr 3 1 3',
  'addr 3 5 5',
  'addi 5 1 5',
  'addr 2 0 0',
  'addi 4 1 4',
  'gtrr 4 1 3',
  'addr 5 3 5',
  'seti 2 4 5',
  'addi 2 1 2',
  'gtrr 2 1 3',
  'addr 3 5 5',
  'seti 1 1 5',
  'mulr 5 5 5',
  'addi 1 2 1',
  'mulr 1 1 1',
  'mulr 5 1 1',
  'muli 1 11 1',
  'addi 3 6 3',
  'mulr 3 5 3',
  'addi 3 15 3',
  'addr 1 3 1',
  'addr 5 0 5',
  'seti 0 7 5',
  'setr 5 8 3',
  'mulr 3 5 3',
  'addr 5 3 3',
  'mulr 5 3 3',
  'muli 3 14 3',
  'mulr 3 5 3',
  'addr 1 3 1',
  'seti 0 0 0',
  'seti 0 6 5',
];

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(solveA(example, example: true), equals(7));
    });
    test('Solution', () {
      expect(solveA(input), equals(984));
    });
  });
  group('Part Two', () {
    test('Solution', () {
      expect(solveB(input), equals(10982400));
    });
  });
}
