// --- Day 4: Repose Record ---
// https://adventofcode.com/2018/day/4

import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_of_code_2018/day04.dart';

const String dataFilePath = 'test/data/day04.txt';

const List<String> example = [
  '[1518-11-01 00:00] Guard #10 begins shift',
  '[1518-11-01 00:05] falls asleep',
  '[1518-11-01 00:25] wakes up',
  '[1518-11-01 00:30] falls asleep',
  '[1518-11-01 00:55] wakes up',
  '[1518-11-01 23:58] Guard #99 begins shift',
  '[1518-11-02 00:40] falls asleep',
  '[1518-11-02 00:50] wakes up',
  '[1518-11-03 00:05] Guard #10 begins shift',
  '[1518-11-03 00:24] falls asleep',
  '[1518-11-03 00:29] wakes up',
  '[1518-11-04 00:02] Guard #99 begins shift',
  '[1518-11-04 00:36] falls asleep',
  '[1518-11-04 00:46] wakes up',
  '[1518-11-05 00:03] Guard #99 begins shift',
  '[1518-11-05 00:45] falls asleep',
  '[1518-11-05 00:55] wakes up',
];

void main() {
  group('Part One', () {
    test('Example 1', () {
      expect(solveA(example), equals(240));
    });
    test('Solution', () {
      expect(solveA(File(dataFilePath).readAsLinesSync()), equals(20859));
    });
  });

  group('Part Two', () {
    test('Example 1', () {
      expect(solveB(example), equals(4455));
    });
    test('Solution', () {
      expect(solveB(File(dataFilePath).readAsLinesSync()), equals(76576));
    });
  });
}
