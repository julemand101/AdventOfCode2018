// --- Day 14: Chocolate Charts ---
// https://adventofcode.com/2018/day/14

import 'package:test/test.dart';
import 'package:advent_of_code_2018/day14.dart';

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(solveA(9), equals('5158916779'));
    });
    test('Example 2', () {
      expect(solveA(5), equals('0124515891'));
    });
    test('Example 3', () {
      expect(solveA(18), equals('9251071085'));
    });
    test('Example 4', () {
      expect(solveA(2018), equals('5941429882'));
    });
    test('Solution', () {
      expect(solveA(909441), equals('2615161213'));
    });
  });

  group('Part Two', () {
    test('Example 1', () {
      expect(solveB([5, 1, 5, 8, 9]), equals(9));
    });
    test('Example 2', () {
      expect(solveB([0, 1, 2, 4, 5]), equals(5));
    });
    test('Example 3', () {
      expect(solveB([9, 2, 5, 1, 0]), equals(18));
    });
    test('Example 4', () {
      expect(solveB([5, 9, 4, 1, 4]), equals(2018));
    });
    test('Solution', () {
      expect(solveB([9, 0, 9, 4, 4, 1]), equals(20403320)); // Ikke 20403321
    });
  });
}
