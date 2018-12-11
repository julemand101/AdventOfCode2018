// --- Day 11: Chronal Charge ---
// https://adventofcode.com/2018/day/11

import 'package:test/test.dart';
import 'package:AdventOfCode2018/day11.dart';

void main() {
  group('Part One', () {
    test('getThirdDigit tests', () {
      expect(Grid.getThirdDigit(1), equals(0));
      expect(Grid.getThirdDigit(12), equals(0));
      expect(Grid.getThirdDigit(123), equals(1));
      expect(Grid.getThirdDigit(1234), equals(2));
      expect(Grid.getThirdDigit(12345), equals(3));
      expect(Grid.getThirdDigit(123456), equals(4));
    });
    test('getPowerLevel tests', () {
      expect(Grid.getPowerLevel(3, 5, 8), equals(4));
      expect(Grid.getPowerLevel(122, 79, 57), equals(-5));
      expect(Grid.getPowerLevel(217, 196, 39), equals(0));
      expect(Grid.getPowerLevel(101, 153, 71), equals(4));
    });
    test('getSquareSum tests', () {
      expect(Grid(18).getSquareSum(33, 45), equals(29));
      expect(Grid(42).getSquareSum(21, 61), equals(30));
    });
    test('Example 1', () {
      expect(solveA(18), equals('33,45'));
    });
    test('Example 2', () {
      expect(solveA(42), equals('21,61'));
    });
    test('Solution', () {
      expect(solveA(7689), equals('20,37'));
    });
  });

  group('Part Two', () {
    test('getSquareSum tests', () {
      expect(Grid(18).getSquareSum(90, 269, squareSize: 16), equals(113));
      expect(Grid(42).getSquareSum(232, 251, squareSize: 12), equals(119));
    });
    test('Example 1', () {
      expect(solveB(18), equals('90,269,16'));
    });
    test('Example 2', () {
      expect(solveB(42), equals('232,251,12'));
    });
    test('Solution', () {
      expect(solveB(7689), equals('90,169,15'));
    });
  });
}
