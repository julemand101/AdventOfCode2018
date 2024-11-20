// --- Day 1: Chronal Calibration ---
// https://adventofcode.com/2018/day/1

import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_of_code_2018/day01.dart';

const String dataFilePath = 'test/data/day01.txt';

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(solveA(['+1', '+1', '+1']), equals(3));
    });
    test('Example 2', () {
      expect(solveA(['+1', '+1', '-2']), equals(0));
    });
    test('Example 3', () {
      expect(solveA(['-1', '-2', '-3']), equals(-6));
    });
    test('Solution', () {
      expect(solveA(File(dataFilePath).readAsLinesSync()), equals(406));
    });
  });

  group('Part Two', () {
    test('Example 1', () {
      expect(solveB(['+1', '-1']), equals(0));
    });
    test('Example 2', () {
      expect(solveB(['+3', '+3', '+4', '-2', '-4']), equals(10));
    });
    test('Example 3', () {
      expect(solveB(['-6', '+3', '+8', '+5', '-6']), equals(5));
    });
    test('Example 4', () {
      expect(solveB(['+7', '+7', '-2', '-7', '-4']), equals(14));
    });
    test('Solution', () {
      expect(solveB(File(dataFilePath).readAsLinesSync()), equals(312));
    });
  });
}
