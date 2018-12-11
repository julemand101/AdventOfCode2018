// --- Day 11: Chronal Charge ---
// https://adventofcode.com/2018/day/11

import 'dart:typed_data';

// Grid is implemented as a summed-area table which makes it a lot more
// efficient to get the sum of specific areas.
//
// For more information:
// https://en.wikipedia.org/wiki/Summed-area_table
class Grid {
  static const int size = 301;
  final List<int> list = Int32List(size * size);

  Grid(int gridSerialNumber) {
    for (var y = 1; y < size; y++) {
      for (var x = 1; x < size; x++) {
        list[x + (y * size)] = getPowerLevel(x, y, gridSerialNumber) +
            get(x, y - 1) +
            get(x - 1, y) -
            get(x - 1, y - 1);
      }
    }
  }

  static int getPowerLevel(int x, int y, int gridSerialNumber) {
    // Find the fuel cell's rack ID, which is its X coordinate plus 10.
    final rackId = x + 10;

    // Begin with a power level of the rack ID times the Y coordinate.
    var powerLevel = rackId * y;

    // Increase the power level by the value of the grid serial number
    // (your puzzle input).
    powerLevel += gridSerialNumber;

    // Set the power level to itself multiplied by the rack ID.
    powerLevel *= rackId;

    // Keep only the hundreds digit of the power level
    // (so 12345 becomes 3; numbers with no hundreds digit become 0).
    powerLevel = getThirdDigit(powerLevel);

    // Subtract 5 from the power level.
    return powerLevel - 5;
  }

  static int getThirdDigit(int number) {
    final string = number.toString();

    if (string.length >= 3) {
      return int.parse(string[string.length - 3]);
    } else {
      return 0;
    }
  }

  int get(int x, int y) => list[x + (y * size)];

  int getSquareSum(int x, int y, {int squareSize = 3}) =>
      _getSquareSum(x - 1, y - 1, squareSize);

  int _getSquareSum(int x, int y, [int squareSize = 3]) =>
      get(x + squareSize, y + squareSize) +
      get(x, y) -
      get(x + squareSize, y) -
      get(x, y + squareSize);
}

String solveA(int gridSerialNumber) {
  final grid = Grid(gridSerialNumber);

  var maxPowerLevelSum = 0;
  var maxX = 0;
  var maxY = 0;

  for (var y = 1; y <= 300 - 3; y++) {
    for (var x = 1; x <= 300 - 3; x++) {
      final powerLevelSum = grid.getSquareSum(x, y);

      if (powerLevelSum > maxPowerLevelSum) {
        maxX = x;
        maxY = y;
        maxPowerLevelSum = powerLevelSum;
      }
    }
  }

  return '$maxX,$maxY';
}

String solveB(int gridSerialNumber) {
  final grid = Grid(gridSerialNumber);

  var maxPowerLevelSum = 0;
  var maxX = 0;
  var maxY = 0;
  var maxSquareSize = 0;

  for (var squareSize = 1; squareSize <= 300; squareSize++) {
    for (var y = 1; y < 300 - squareSize; y++) {
      for (var x = 1; x < 300 - squareSize; x++) {
        final powerLevelSum = grid.getSquareSum(x, y, squareSize: squareSize);

        if (powerLevelSum > maxPowerLevelSum) {
          maxX = x;
          maxY = y;
          maxSquareSize = squareSize;
          maxPowerLevelSum = powerLevelSum;
        }
      }
    }
  }

  return '$maxX,$maxY,$maxSquareSize';
}
