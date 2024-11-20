// --- Day 7: The Sum of Its Parts ---
// https://adventofcode.com/2018/day/7

import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_of_code_2018/day07.dart';

const String dataFilePath = 'test/data/day07.txt';

const List<String> example = [
  'Step C must be finished before step A can begin.',
  'Step C must be finished before step F can begin.',
  'Step A must be finished before step B can begin.',
  'Step A must be finished before step D can begin.',
  'Step B must be finished before step E can begin.',
  'Step D must be finished before step E can begin.',
  'Step F must be finished before step E can begin.'
];

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(solveA(example), equals('CABDFE'));
    });
    test('Solution', () {
      expect(solveA(File(dataFilePath).readAsLinesSync()),
          equals('GKPTSLUXBIJMNCADFOVHEWYQRZ'));
    });
  });

  group('Part Two', () {
    test('Example 1', () {
      expect(solveB(example, 2, 0), equals(15));
    });
    test('Solution', () {
      expect(solveB(File(dataFilePath).readAsLinesSync(), 5, 60), equals(920));
    });
  });
}
