// --- Day 5: Alchemical Reduction ---
// https://adventofcode.com/2018/day/5

const int toSmallLetter = 32;
const int toBigLetter = -toSmallLetter;
const int letterBigA = 65;
const int letterBigZ = 90;

int solveA(Iterable<int> units) {
  final polymer = <int>[];

  for (var unit in units) {
    if (polymer.isNotEmpty && _isReacting(polymer.last, unit)) {
      polymer.removeLast();
    } else {
      polymer.add(unit);
    }
  }

  return polymer.length;
}

bool _isReacting(int a, int b) =>
    a - b == toBigLetter || a - b == toSmallLetter;

int solveB(Iterable<int> units) {
  var minSize = units.length;

  for (var bigLetter = letterBigA; bigLetter <= letterBigZ; bigLetter++) {
    final size = solveA(units.where((unit) => _test(unit, bigLetter)));
    minSize = (size < minSize) ? size : minSize;
  }

  return minSize;
}

bool _test(int unit, int bigLetter) =>
    unit != bigLetter && unit != bigLetter + toSmallLetter;
