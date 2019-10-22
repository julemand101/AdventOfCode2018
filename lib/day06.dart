// --- Day 6: Chronal Coordinates ---
// https://adventofcode.com/2018/day/6

import 'dart:math';

class Coordinate extends Point<int> {
  const Coordinate(int x, int y) : super(x, y);

  int manhattanDistanceByCoordinate(int x, int y) =>
      (this.x - x).abs() + (this.y - y).abs();
}

class Grid {
  final List<Coordinate> coordinates;

  int maxX = 0;
  int minX = 0;
  int maxY = 0;
  int minY = 0;

  Grid(this.coordinates) {
    for (final coordinate in coordinates) {
      maxX = max(coordinate.x, maxX);
      minX = min(coordinate.x, minX);

      maxY = max(coordinate.y, maxY);
      minY = min(coordinate.y, minY);
    }
  }

  Coordinate closestPoint(int x, int y) {
    Coordinate closestCoordinate;
    int minDistance;

    for (final coordinate in coordinates) {
      final distance = coordinate.manhattanDistanceByCoordinate(x, y);

      if (minDistance == null) {
        closestCoordinate = coordinate;
        minDistance = distance;
      } else if (distance == minDistance) {
        closestCoordinate = null;
      } else if (distance < minDistance) {
        closestCoordinate = coordinate;
        minDistance = distance;
      }
    }

    // null if two points has the same closest distance
    return closestCoordinate;
  }

  int getDistanceSum(int x, int y) => coordinates.fold(
      0, (prev, element) => prev + element.manhattanDistanceByCoordinate(x, y));

  // Get all coordinates which does not reach the edge of the grid since these
  // coordinates are going to expand into infinity
  List<Coordinate> getValidCoordinates() {
    final validCoordinates = coordinates.toList();

    for (var x = minX; x <= maxX; x++) {
      validCoordinates
        ..remove(closestPoint(x, minY))
        ..remove(closestPoint(x, maxY));
    }

    for (var y = minY; y <= maxY; y++) {
      validCoordinates
        ..remove(closestPoint(minX, y))
        ..remove(closestPoint(maxX, y));
    }

    return validCoordinates;
  }
}

int solveA(List<String> input) {
  final grid = Grid(input.map(_parseToCoordinate).toList());

  final validCoordinatesToSize = Map<Coordinate, int>.fromEntries(
      grid.getValidCoordinates().map((coordinate) => MapEntry(coordinate, 0)));

  // We don't need to search the edge since all coordinates there are part of
  // the edge has been removed from the list of valid coordinates
  for (var x = grid.minX + 1; x < grid.maxX; x++) {
    for (var y = grid.minY + 1; y < grid.maxY; y++) {
      final coordinate = grid.closestPoint(x, y);

      if (validCoordinatesToSize.containsKey(coordinate)) {
        validCoordinatesToSize[coordinate]++;
      }
    }
  }

  return validCoordinatesToSize.values.fold(0, max);
}

int solveB(List<String> input, int totalDistanceLessThan) {
  final grid = Grid(input.map(_parseToCoordinate).toList());
  var areaSize = 0;

  for (var x = grid.minX; x <= grid.maxX; x++) {
    for (var y = grid.minY; y <= grid.maxY; y++) {
      if (grid.getDistanceSum(x, y) < totalDistanceLessThan) {
        areaSize++;
      }
    }
  }

  return areaSize;
}

Coordinate _parseToCoordinate(String line) {
  final parts = line.split(', ');
  return Coordinate(int.parse(parts[0]), int.parse(parts[1]));
}
