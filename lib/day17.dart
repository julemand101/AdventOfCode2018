// --- Day 17: Reservoir Research ---
// https://adventofcode.com/2018/day/17

import 'dart:math';

enum GridState { clay, sand, waterSpring, movingWater, restingWater, bottom }

class Grid {
  final int offSetX;
  final int length, height;
  final List<GridState> list;

  factory Grid(List<String> lines) {
    final regEx = RegExp(r'(x|y)=(\d*), (x|y)=(\d*)..(\d*)');

    var minX = 100000, maxX = 0, maxY = 0;
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
        minX = min(minX, singleCoordinate);
        maxX = max(maxX, singleCoordinate);
        maxY = max(maxY, rangeTo);
      } else if (singleLetter == 'y') {
        for (var x = rangeFrom; x <= rangeTo; x++) {
          points.add(Point(x, singleCoordinate));
        }
        minX = min(minX, rangeFrom);
        maxX = max(maxX, rangeTo);
        maxY = max(maxY, singleCoordinate);
      } else {
        throw Exception('$singleLetter is not x or y');
      }
    }

    final grid = Grid._filled(minX - 1, maxX + 2, maxY + 2, GridState.sand)
      ..set(500, 0, GridState.waterSpring);

    for (var point in points) {
      grid.set(point.x, point.y, GridState.clay);
    }

    for (var x = minX - 1; x < maxX + 2; x++) {
      grid.set(x, maxY + 1, GridState.bottom);
    }

    return grid;
  }

  Grid._filled(this.offSetX, int length, this.height, GridState value)
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
          case GridState.waterSpring:
            sb.write('+');
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

int solveA(List<String> lines) {
  final grid = Grid(lines);
  print(grid);

  return 0;
}
