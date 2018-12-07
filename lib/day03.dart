// --- Day 3: No Matter How You Slice It ---
// https://adventofcode.com/2018/day/3

import 'dart:math';

class Claim {
  // #1 @ 1,3: 4x4
  static final _exp = RegExp(r'#(\d+) @ (\d+),(\d+): (\d+)x(\d+)');

  int id, x, y, wide, tall;

  Claim(String input) {
    final matches = _exp.firstMatch(input);

    id = int.parse(matches.group(1));
    x = int.parse(matches.group(2));
    y = int.parse(matches.group(3));
    wide = int.parse(matches.group(4));
    tall = int.parse(matches.group(5));
  }
}

int solveA(List<String> input) {
  // Key = xy coordinate, Value = number of overlap
  final map = <Point<int>, int>{};

  for (var line in input) {
    final claim = Claim(line);

    for (var i = 0; i < claim.wide; i++) {
      for (var k = 0; k < claim.tall; k++) {
        final coordinate = Point(claim.x + i, claim.y + k);
        map.update(coordinate, (value) => value + 1, ifAbsent: () => 1);
      }
    }
  }

  return map.values.where((value) => value > 1).length;
}

int solveB(List<String> input) {
  // Key = xy coordinate, Value = ID of claim.
  final map = <Point<int>, int>{};
  final notOverlappingIds = Set<int>();

  for (var line in input) {
    final claim = Claim(line);

    // Assume no overlap
    notOverlappingIds.add(claim.id);

    for (var i = 0; i < claim.wide; i++) {
      for (var k = 0; k < claim.tall; k++) {
        final coordinate = Point(claim.x + i, claim.y + k);
        map.update(coordinate, (origClaimId) {
          // Remove both ID's from the notOverlappingIds list if we overlap
          notOverlappingIds..remove(origClaimId)..remove(claim.id);
          return origClaimId;
        }, ifAbsent: () => claim.id);
      }
    }
  }

  if (notOverlappingIds.length == 1) {
    return notOverlappingIds.first;
  } else {
    throw Exception('Length of list is: ${notOverlappingIds.length}');
  }
}
