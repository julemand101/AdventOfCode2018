// --- Day 17: Reservoir Research ---
// https://adventofcode.com/2018/day/17

import 'dart:math';

enum GridState {
  /// #
  clay,

  /// .
  sand,

  /// |
  movingWater,

  /// ~
  restingWater,

  /// ¤
  bottom
}

class Grid {
  final int offSetX;
  final int length, height;
  final List<GridState> list;
  final int lowestY;

  factory Grid(List<String> lines) {
    final regEx = RegExp(r'(x|y)=(\d*), (x|y)=(\d*)..(\d*)');

    var minX = 100000, maxX = 0, maxY = 0, lowestY = 10000;
    final points = <Point<int>>[];

    for (var line in lines) {
      final match = regEx.firstMatch(line);
      final singleLetter = match.group(1); // x or y
      final singleCoordinate = int.parse(match.group(2));
      final rangeFrom = int.parse(match.group(4));
      final rangeTo = int.parse(match.group(5));

      if (singleLetter == 'x') {
        for (var y = rangeFrom; y <= rangeTo; y++) {
          points.add(Point(singleCoordinate, y));
        }
        lowestY = min(lowestY, rangeFrom);
        minX = min(minX, singleCoordinate);
        maxX = max(maxX, singleCoordinate);
        maxY = max(maxY, rangeTo);
      } else if (singleLetter == 'y') {
        for (var x = rangeFrom; x <= rangeTo; x++) {
          points.add(Point(x, singleCoordinate));
        }
        lowestY = min(lowestY, singleCoordinate);
        minX = min(minX, rangeFrom);
        maxX = max(maxX, rangeTo);
        maxY = max(maxY, singleCoordinate);
      } else {
        throw Exception('$singleLetter is not x or y');
      }
    }

    final grid =
        Grid._filled(minX - 1, maxX + 2, maxY + 2, lowestY, GridState.sand);

    for (var point in points) {
      grid.set(point.x, point.y, GridState.clay);
    }

    for (var x = minX - 1; x < maxX + 2; x++) {
      grid.set(x, maxY + 1, GridState.bottom);
    }

    return grid;
  }

  Grid._filled(
      this.offSetX, int length, this.height, this.lowestY, GridState value)
      : list = List.filled((length - offSetX) * height, value),
        length = length - offSetX;

  GridState get(int x, int y) => list[_getPos(x, y)];
  void set(int x, int y, GridState value) => list[_getPos(x, y)] = value;

  int _getPos(int x, int y) => (x - offSetX) + (y * length);

  @override
  String toString() {
    final sb = StringBuffer();

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < length; x++) {
        switch (get(x + offSetX, y)) {
          case GridState.clay:
            sb.write('#');
            break;
          case GridState.sand:
            sb.write('.');
            break;
          case GridState.movingWater:
            sb.write('|');
            break;
          case GridState.restingWater:
            sb.write('~');
            break;
          case GridState.bottom:
            sb.write('¤');
            break;
        }
      }
      sb.writeln();
    }

    return sb.toString();
  }
}

Grid simulateWaterFlow(List<String> lines) {
  final grid = Grid(lines);
  final waterSprings = [const Point(500, 0)];

  while (waterSprings.isNotEmpty) {
    final startPoint = waterSprings.removeAt(0);
    final x = startPoint.x;
    var y = startPoint.y;

    do {
      grid.set(x, y++, GridState.movingWater);
    } while (grid.get(x, y) == GridState.sand);
    y--; // Go one step up since we are at clay level

    // Check if we hit bottom
    if (grid.get(x, y + 1) == GridState.bottom ||
        grid.get(x, y + 1) == GridState.movingWater) {
      continue;
    }

    if (!wallsOnBothSides(grid, x, y)) {
      if (grid.get(x + 1, y) == GridState.sand) {
        waterSprings.add(Point(x + 1, y));
      }
      if (grid.get(x - 1, y) == GridState.sand) {
        waterSprings.add(Point(x - 1, y));
      }
      continue;
    }

    while (wallsOnBothSides(grid, x, y)) {
      // Fill left
      for (var x1 = x; grid.get(x1, y) != GridState.clay; x1--) {
        grid.set(x1, y, GridState.restingWater);
      }

      // Fill right
      for (var x1 = x; grid.get(x1, y) != GridState.clay; x1++) {
        grid.set(x1, y, GridState.restingWater);
      }
      y--;
    }

    // Insert new water springs
    // Left
    for (var x1 = x; grid.get(x1, y) != GridState.clay; x1--) {
      grid.set(x1, y, GridState.movingWater);

      if (grid.get(x1, y + 1) == GridState.sand) {
        final point = Point(x1, y);
        if (!waterSprings.contains(point)) {
          waterSprings.add(point);
        }
        break;
      }
    }

    // Right
    for (var x1 = x; grid.get(x1, y) != GridState.clay; x1++) {
      grid.set(x1, y, GridState.movingWater);

      if (grid.get(x1, y + 1) == GridState.sand) {
        final point = Point(x1, y);
        if (!waterSprings.contains(point)) {
          waterSprings.add(point);
        }
        break;
      }
    }
  }

  return grid;
}

int solveA(List<String> lines) {
  final grid = simulateWaterFlow(lines);

  return grid.list
          .where((block) =>
              block == GridState.restingWater || block == GridState.movingWater)
          .length -
      grid.lowestY; // Don't count the starting water spring
}

int solveB(List<String> lines) {
  final grid = simulateWaterFlow(lines);
  return grid.list.where((block) => block == GridState.restingWater).length;
}

bool wallsOnBothSides(Grid grid, int startX, int startY) {
  // Check left
  var x = startX;
  var y = startY;

  while (grid.get(x, y) != GridState.clay &&
      (grid.get(x, y + 1) == GridState.clay ||
          grid.get(x, y + 1) == GridState.restingWater)) {
    x--;
  }

  if (grid.get(x, y) == GridState.clay) {
    // Check right
    x = startX;
    y = startY;

    while (grid.get(x, y) != GridState.clay &&
        (grid.get(x, y + 1) == GridState.clay ||
            grid.get(x, y + 1) == GridState.restingWater)) {
      x++;
    }

    if (grid.get(x, y) == GridState.clay) {
      return true;
    }
  }

  return false;
}
