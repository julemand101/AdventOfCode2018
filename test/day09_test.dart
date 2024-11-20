// --- Day 9: Marble Mania ---
// https://adventofcode.com/2018/day/9

import 'package:test/test.dart';
import 'package:advent_of_code_2018/day09.dart';

void main() {
  group('Part One', () {
    test('Example 1', () {
      // 9 players; last marble is worth 25 points: high score is 32
      expect(solve(9, 25), equals(32));
    });
    test('Example 2', () {
      // 10 players; last marble is worth 1618 points: high score is 8317
      expect(solve(10, 1618), equals(8317));
    });
    test('Example 3', () {
      // 13 players; last marble is worth 7999 points: high score is 146373
      expect(solve(13, 7999), equals(146373));
    });
    test('Example 4', () {
      // 17 players; last marble is worth 1104 points: high score is 2764
      expect(solve(17, 1104), equals(2764));
    });
    test('Example 5', () {
      // 21 players; last marble is worth 6111 points: high score is 54718
      expect(solve(21, 6111), equals(54718));
    });
    test('Example 6', () {
      // 30 players; last marble is worth 5807 points: high score is 37305
      expect(solve(30, 5807), equals(37305));
    });
    test('Solution', () {
      // 411 players; last marble is worth 72059 points
      expect(solve(411, 72059), equals(429943));
    });
  });

  group('Part Two', () {
    test('Solution', () {
      // Elf's score be if the number of the last marble were 100 times larger?
      expect(solve(411, 72059 * 100), equals(3615691746));
    });
  });
}
