// --- Day 10: The Stars Align ---
// https://adventofcode.com/2018/day/10

import 'dart:math' as math;

class Point {
  final int _x;
  final int _y;
  final int _velocityX;
  final int _velocityY;

  static final _exp = RegExp(r'position=<([- ]?\d*), ([- ]?\d*)> '
      r'velocity=<([- ]?\d*), ([- ]?\d*)>');

  const Point(this._x, this._y, this._velocityX, this._velocityY);

  factory Point.fromLine(String line) {
    final matches = _exp.firstMatch(line);

    final x = int.parse(matches.group(1));
    final y = int.parse(matches.group(2));
    final velocityX = int.parse(matches.group(3));
    final velocityY = int.parse(matches.group(4));

    return Point(x, y, velocityX, velocityY);
  }

  int getX(int time) => _x + (_velocityX * time);
  int getY(int time) => _y + (_velocityY * time);
}

class PuzzleAnswer {
  final String message;
  final int seconds;

  const PuzzleAnswer(this.message, this.seconds);
}

PuzzleAnswer solve(List<String> input) {
  final points = input.map((line) => Point.fromLine(line)).toList();

  int time = -1, height, length, maxX, maxY, minX, minY;
  int prevTime, prevHeight, prevLength, prevMinX, prevMinY;

  // So the strategy for this solution is to find the point in time where the
  // height of the area of points is smallest.
  while (prevHeight == null || height == null || height < prevHeight) {
    // Note last success so we can go back in time for the solution
    prevTime = time++;
    prevHeight = height;
    prevLength = length;
    prevMinX = minX;
    prevMinY = minY;

    // Find the size of area we need for draw all points on this point in time
    maxX = points.first.getX(time);
    maxY = points.first.getY(time);
    minX = maxX;
    minY = maxY;

    for (final point in points) {
      final x = point.getX(time);
      final y = point.getY(time);

      maxX = math.max(x, maxX);
      maxY = math.max(y, maxY);
      minX = math.min(x, minX);
      minY = math.min(y, minY);
    }

    length = (maxX - minX).abs();
    height = (maxY - minY).abs();
  }

  final grid = _build2dGrid(prevHeight, prevLength, ' ');

  for (final point in points) {
    // Convert each coordinate so 0 are the smallest value for both x and y
    final x = point.getX(prevTime) + (prevMinX * -1);
    final y = point.getY(prevTime) + (prevMinY * -1);

    grid[y][x] = '#';
  }

  final sb = StringBuffer();

  for (final line in grid) {
    line.forEach(sb.write);
    sb.writeln();
  }

  return PuzzleAnswer(sb.toString(), prevTime);
}

// We need to add 1 since height and length represents the max value inclusive
List<List<String>> _build2dGrid(int height, int length, String data) =>
    List.generate(height + 1, (_) => List.generate(length + 1, (_) => data));
