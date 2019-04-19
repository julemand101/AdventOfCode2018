// --- Day 15: Beverage Bandits ---
// https://adventofcode.com/2018/day/15

abstract class Point {
  final Map map;
  int x, y;

  Point(this.map, this.x, this.y);

  Iterable<Point> get adjacentPoints sync* {
    // Up
    if (y - 1 >= 0) {
      yield map.getPoint(x, y - 1);
    }

    // Down
    if (y + 1 < map.grid.height) {
      yield map.getPoint(x, y + 1);
    }

    // Left
    if (x - 1 >= 0) {
      yield map.getPoint(x - 1, y);
    }

    // Right
    if (x + 1 < map.grid.length) {
      yield map.getPoint(x + 1, y);
    }
  }

  Iterable<Point> get openAdjacentPoints => adjacentPoints.whereType<Empty>();
}

class Wall extends Point {
  Wall(Map map, int x, int y) : super(map, x, y);

  @override
  String toString() => '#';
}

class Empty extends Point {
  Empty(Map map, int x, int y) : super(map, x, y);

  @override
  String toString() => '.';
}

abstract class Character extends Point {
  final int attackPower = 3;
  int hp = 200;

  Character(Map map, int x, int y) : super(map, x, y);

  void moveTo(int newX, int newY) {
    final point = map.getPoint(newX, newY);

    if (point is! Empty) {
      throw Exception('$x,$y are not empty but contains $point');
    }

    point
      ..x = x
      ..y = y;

    map..setPoint(x, y, point)..setPoint(newX, newY, this);

    x = newX;
    y = newY;
  }

  Iterable<Character> get enemies;
}

class Goblin extends Character {
  Goblin(Map map, int x, int y) : super(map, x, y);

  @override
  Iterable<Character> get enemies => map.grid.list.whereType<Elf>();

  @override
  String toString() => 'G';
}

class Elf extends Character {
  Elf(Map map, int x, int y) : super(map, x, y);

  @override
  Iterable<Character> get enemies => map.grid.list.whereType<Goblin>();

  @override
  String toString() => 'E';
}

//    ____      _     _
//   / ___|_ __(_) __| |
//  | |  _| '__| |/ _` |
//  | |_| | |  | | (_| |
//   \____|_|  |_|\__,_|
//
class Grid<T> {
  final int length, height;
  final List<T> list;

  Grid(this.length, this.height) : list = List(length * height);
  Grid.filled(this.length, this.height, T value)
      : list = List(length * height) {
    setAll(value);
  }

  T get(int x, int y) => list[_getPos(x, y)];
  void set(int x, int y, T value) => list[_getPos(x, y)] = value;
  void setAll(T value) {
    for (var i = 0; i < list.length; i++) {
      list[i] = value;
    }
  }

  int _getPos(int x, int y) => x + (y * length);

  @override
  String toString() {
    final sb = StringBuffer();

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < length; x++) {
        sb.write(get(x, y) ?? ' ');
      }
      sb.writeln();
    }

    return sb.toString();
  }
}

//   __  __
//  |  \/  | __ _ _ __
//  | |\/| |/ _` | '_ \
//  | |  | | (_| | |_) |
//  |_|  |_|\__,_| .__/
//               |_|
class Map {
  Grid<Point> grid;

  Map(List<String> input) {
    final length = input[0].length;
    final height = input.length;
    grid = Grid(length, height);

    // Parse
    for (var y = 0; y < height; y++) {
      final line = input[y];

      for (var x = 0; x < line.length; x++) {
        grid.set(x, y, _parse(line[x], this, x, y));
      }
    }
  }

  static Point _parse(String char, Map map, int x, int y) {
    switch (char) {
      case '#':
        return Wall(map, x, y);
      case '.':
        return Empty(map, x, y);
      case 'G':
        return Goblin(map, x, y);
      case 'E':
        return Elf(map, x, y);
      default:
        throw Exception('$char are not a valid char.');
    }
  }

  Point getPoint(int x, int y) => grid.get(x, y);
  void setPoint(int x, int y, Point value) => grid.set(x, y, value);

  Iterable<Character> getTurnOrder() => grid.list.whereType<Character>();

  @override
  String toString() => grid.toString();
}

//             _              _
//   ___  ___ | |_   _____   / \
//  / __|/ _ \| \ \ / / _ \ / _ \
//  \__ \ (_) | |\ V /  __// ___ \
//  |___/\___/|_| \_/ \___/_/   \_\
//
int solveA(List<String> input) {
  final test = Map(['#######', '#E..G.#', '#...#.#', '#.G.#G#', '#######']);
  final grid = Grid<int>(test.grid.length, test.grid.height);
  print(test);

  final elf = test.getPoint(1, 1);

  final queue = elf.openAdjacentPoints.toList();
  var length = 1;

  while (queue.isNotEmpty) {
    for (var point in queue.toList()) {
      final x = point.x;
      final y = point.y;
      final gridValue = grid.get(x, y);

      if (gridValue == null || gridValue > length) {
        grid.set(x, y, length);
      }

      for (var char in point.adjacentPoints.whereType<Character>()) {
        if (char != elf && grid.get(char.x, char.y) == null) {
          grid.set(char.x, char.y, length + 1);
        }
      }

      queue
        ..remove(point)
        ..addAll(
            point.openAdjacentPoints.where((p) => grid.get(p.x, p.y) == null));
    }

    length++;
  }

  print(grid);

  return -1;
  final map = Map(input);
  print(map);

  print('------------------------------');
  input.forEach(print);

  map.getTurnOrder().forEach((c) => print('$c(${c.x},${c.y})'));
  map.getTurnOrder().first.moveTo(2, 1);
  print(map);

  final p = map.getPoint(2, 1);

  print(p.x);
  print(p.y);

  if (p is Character) {
    p.adjacentPoints.forEach(print);

    final g = Grid.filled(map.grid.length, map.grid.height, '.');

    for (var e in p.enemies) {
      g.set(e.x, e.y, 'E');
      for (var a in e.openAdjacentPoints) {
        g.set(a.x, a.y, '?');
      }
    }

    print(g);
  }
}
