// --- Day 8: Memory Maneuver ---
// https://adventofcode.com/2018/day/8

import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_of_code_2018/day08.dart';

const String dataFilePath = 'test/data/day08.txt';

const List<int> example = [2, 3, 0, 3, 10, 11, 12, 1, 1, 0, 1, 99, 2, 1, 1, 2];

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(solveA(example), equals(138));
    });

    test('Solution', () {
      expect(
          solveA(File(dataFilePath)
              .readAsLinesSync()
              .first
              .split(' ')
              .map(int.parse)
              .toList()),
          equals(42146));
    });
  });

  group('Part One', () {
    test('Example 1', () {
      expect(solveB(example), equals(66));
    });

    test('Solution', () {
      expect(
          solveB(File(dataFilePath)
              .readAsLinesSync()
              .first
              .split(' ')
              .map(int.parse)
              .toList()),
          equals(26753));
    });
  });
}
