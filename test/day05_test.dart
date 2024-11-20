// --- Day 5: Alchemical Reduction ---
// https://adventofcode.com/2018/day/5

import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_of_code_2018/day05.dart';

const String dataFilePath = 'test/data/day05.txt';

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(solveA('aA'.codeUnits), equals(0));
    });
    test('Example 2', () {
      expect(solveA('abBA'.codeUnits), equals(0));
    });
    test('Example 3', () {
      expect(solveA('abAB'.codeUnits), equals(4));
    });
    test('Example 4', () {
      expect(solveA('aabAAB'.codeUnits), equals(6));
    });
    test('Example 5', () {
      expect(solveA('dabAcCaCBAcCcaDA'.codeUnits), equals(10));
    });
    test('Solution', () {
      expect(solveA(File(dataFilePath).readAsBytesSync()), equals(11720));
    });
  });

  group('Part Two', () {
    test('Example 1', () {
      expect(solveB('dabAcCaCBAcCcaDA'.codeUnits), equals(4));
    });
    test('Solution', () {
      expect(solveB(File(dataFilePath).readAsBytesSync()), equals(4956));
    });
  });
}
