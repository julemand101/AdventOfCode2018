// --- Day 2: Inventory Management System ---
// https://adventofcode.com/2018/day/2

import 'dart:io';
import 'package:test/test.dart';
import 'package:AdventOfCode2018/day02.dart';

const String dataFilePath = 'test/data/day02.txt';

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(
          solveA([
            'abcdef',
            'bababc',
            'abbcde',
            'abcccd',
            'aabcdd',
            'abcdee',
            'ababab'
          ]),
          equals(12));
    });
    test('Solution', () {
      expect(solveA(File(dataFilePath).readAsLinesSync()), equals(8118));
    });
  });

  group('Part Two', () {
    test('Example 1', () {
      expect(
          solveB(
              ['abcde', 'fghij', 'klmno', 'pqrst', 'fguij', 'axcye', 'wvxyz']),
          equals('fgij'));
    });
    test('Solution', () {
      expect(solveB(File(dataFilePath).readAsLinesSync()),
          equals('jbbenqtlaxhivmwyscjukztdp'));
    });
  });
}
