// --- Day 13: Mine Cart Madness ---
// https://adventofcode.com/2018/day/13

import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_of_code_2018/day13.dart';

const String dataFilePath = 'test/data/day13.txt';

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(
          solveA([
            r'/->-\',
            r'|   |  /----\',
            r'| /-+--+-\  |',
            r'| | |  | v  |',
            r'\-+-/  \-+--/',
            r'  \------/'
          ]),
          equals('7,3'));
    });
    test('Solution', () {
      expect(solveA(File(dataFilePath).readAsLinesSync()), equals('26,92'));
    });
  });

  group('Part Two', () {
    test('Example 1', () {
      expect(
          solveB([
            r'/>-<\',
            r'|   |',
            r'| /<+-\',
            r'| | | v',
            r'\>+</ |',
            r'  |   ^',
            r'  \<->/'
          ]),
          equals('6,4'));
    });
    test('Solution', () {
      expect(solveB(File(dataFilePath).readAsLinesSync()), equals('86,18'));
    });
  });
}
