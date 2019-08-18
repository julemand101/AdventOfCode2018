// --- Day 15: Beverage Bandits ---
// https://adventofcode.com/2018/day/15

import 'dart:math' as math;

// Used to mark which classes we allow to travel to when calculating route
abstract class Destination {}

//   ____       _       _
//  |  _ \ ___ (_)_ __ | |_
//  | |_) / _ \| | '_ \| __|
//  |  __/ (_) | | | | | |_
//  |_|   \___/|_|_| |_|\__|
//
abstract class Point {
  final Map map;
  int x, y;

  Point(this.map, this.x, this.y);

  Iterable<Point> get adjacentPoints sync* {
    // Up
    if (y - 1 >= 0) {
      yield map.getPoint(x, y - 1);
    }

    // Left
    if (x - 1 >= 0) {
      yield map.getPoint(x - 1, y);
    }

    // Right
    if (x + 1 < map.grid.length) {
      yield map.getPoint(x + 1, y);
    }

    // Down
    if (y + 1 < map.grid.height) {
      yield map.getPoint(x, y + 1);
    }
  }

  Iterable<Point> get openAdjacentPoints => adjacentPoints.whereType<Empty>();
}

//  __        __    _ _
//  \ \      / /_ _| | |
//   \ \ /\ / / _` | | |
//    \ V  V / (_| | | |
//     \_/\_/ \__,_|_|_|
//
class Wall extends Point {
  Wall(Map map, int x, int y) : super(map, x, y);

  @override
  String toString() => '#';
}

//   _____                 _
//  | ____|_ __ ___  _ __ | |_ _   _
//  |  _| | '_ ` _ \| '_ \| __| | | |
//  | |___| | | | | | |_) | |_| |_| |
//  |_____|_| |_| |_| .__/ \__|\__, |
//                  |_|        |___/
class Empty extends Point implements Destination {
  Empty(Map map, int x, int y) : super(map, x, y);

  @override
  String toString() => '.';
}

//    ____ _                          _
//   / ___| |__   __ _ _ __ __ _  ___| |_ ___ _ __
//  | |   | '_ \ / _` | '__/ _` |/ __| __/ _ \ '__|
//  | |___| | | | (_| | | | (_| | (__| |_  __/ |
//   \____|_| |_|\__,_|_|  \__,_|\___|\__\___|_|
//
abstract class Character extends Point implements Destination {
  static const int attackPower = 3;
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

  void attack(Character c) {
    c.hp -= Character.attackPower;

    if (c.hp < 0) {
      map.setPoint(c.x, c.y, Empty(map, c.x, c.y));
    }
  }

  bool get isAlive => hp > 0;
  bool get isDead => !isAlive;
  Iterable<Character> get enemies;
  Iterable<Character> get adjacentEnemies;

  Route getRouteToNearestEnemy();

  Route _getRouteToNearestEnemy(bool Function(Point) check) {
    final queue = <Point, Route>{};

    // Add empty spaces to route generator
    for (var empty in map.grid.list.whereType<Destination>().cast<Point>()) {
      queue[empty] = Route(empty);
    }

    // Set point where we want to search from
    queue[this].length = 0;

    while (queue.values.any((p) => p.length != null)) {
      final u = queue.values
          .where(_routeHaveLength)
          .reduce(_findRouteWithShortestLength);

      queue.remove(u.point);

      if (u.point is! Character || u.length == 0) {
        for (var v in u.point.adjacentPoints.where(queue.containsKey)) {
          final alt = u.length + 1;
          final route = queue[v];

          if (route.length == null || alt < route.length) {
            route
              ..length = alt
              ..prev = u;
          }

          if (check(v)) {
            return route;
          }
        }
      }
    }

    return null;
  }

  static bool _routeHaveLength(Route r) => r.length != null;
  static Route _findRouteWithShortestLength(Route a, Route b) =>
      (a.length > b.length) ? b : a;
}

//    ____       _     _ _
//   / ___| ___ | |__ | (_)_ __
//  | |  _ / _ \| '_ \| | | '_ \
//  | |_| | (_) | |_) | | | | | |
//   \____|\___/|_.__/|_|_|_| |_|
//
class Goblin extends Character {
  Goblin(Map map, int x, int y) : super(map, x, y);

  @override
  Iterable<Character> get enemies => map.grid.list.whereType<Elf>();

  @override
  Iterable<Character> get adjacentEnemies => adjacentPoints.whereType<Elf>();

  @override
  Route getRouteToNearestEnemy() =>
      _getRouteToNearestEnemy((point) => point is Elf);

  @override
  String toString() => 'G';
}

//   _____ _  __
//  | ____| |/ _|
//  |  _| | | |_
//  | |___| |  _|
//  |_____|_|_|
//
class Elf extends Character {
  Elf(Map map, int x, int y) : super(map, x, y);

  @override
  Iterable<Character> get enemies => map.grid.list.whereType<Goblin>();

  @override
  Iterable<Character> get adjacentEnemies => adjacentPoints.whereType<Goblin>();

  @override
  Route getRouteToNearestEnemy() =>
      _getRouteToNearestEnemy((point) => point is Goblin);

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
      : list = List.filled(length * height, value);
  Grid.generate(this.length, this.height, T generate(int index))
      : list = List.generate(length * height, generate);

  T get(int x, int y) => list[_getPos(x, y)];
  void set(int x, int y, T value) => list[_getPos(x, y)] = value;

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
  Iterable<Elf> get elvers => grid.list.whereType<Elf>();
  Iterable<Goblin> get goblins => grid.list.whereType<Goblin>();

  @override
  String toString() => grid.toString();
}

//   ____             _
//  |  _ \ ___  _   _| |_ ___
//  | |_) / _ \| | | | __/ _ \
//  |  _ < (_) | |_| | |_  __/
//  |_| \_\___/ \__,_|\__\___|
//
class Route {
  final Point point;
  Route prev;
  int length;

  Route(this.point);

  Iterable<Route> getRoute() sync* {
    yield this;

    if (prev != null) {
      yield* prev.getRoute();
    }
  }

  Point get nextStep => getRoute().firstWhere((r) => r.length == 1).point;

  @override
  String toString() => (length != null) ? length.toString() : '_';
}

//             _              _
//   ___  ___ | |_   _____   / \
//  / __|/ _ \| \ \ / / _ \ / _ \
//  \__ \ (_) | |\ V /  __// ___ \
//  |___/\___/|_| \_/ \___/_/   \_\
//
int solveA(List<String> input) {
  final map = Map(input);
  var rounds = 0;

  mainLoop:
  while (map.elvers.isNotEmpty && map.goblins.isNotEmpty) {
    for (var character in map.getTurnOrder().toList()) {
      if (character.isDead) {
        continue;
      }

      if (character.enemies.isEmpty) {
        break mainLoop;
      }

      final nextPoint = character.getRouteToNearestEnemy()?.nextStep;
      if (nextPoint is Empty) {
        character.moveTo(nextPoint.x, nextPoint.y);
      }

      final enemies = character.adjacentEnemies.toList(growable: false);

      if (enemies.isNotEmpty) {
        final minHp = enemies.fold<int>(
            enemies.first.hp, (minHp, enemy) => math.min(minHp, enemy.hp));

        final selectedEnemy = enemies.firstWhere((enemy) => enemy.hp == minHp);
        character.attack(selectedEnemy);
      }
    }
    rounds++;
  }

  final survivors = (map.elvers.isEmpty) ? map.goblins : map.elvers;
  return survivors.fold<int>(0, (sum, goblin) => sum + goblin.hp) * rounds;
}
