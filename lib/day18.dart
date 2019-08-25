// --- Day 18: Settlers of The North Pole ---
// https://adventofcode.com/2018/day/18

enum AcreType {
  /// .
  openGround,

  /// |
  trees,

  /// #
  lumberyard
}

class Forrest {
  final int length, height;
  final List<AcreType> list;

  Forrest(List<String> lines)
      : length = lines[0].length,
        height = lines.length,
        list = List(lines[0].length * lines.length) {
    for (var y = 0; y < lines.length; y++) {
      for (var x = 0; x < lines[y].length; x++) {
        set(x, y, _parse(lines[y][x]));
      }
    }
  }

  Forrest._(this.length, this.height, this.list);

  static AcreType _parse(String acre) {
    switch (acre) {
      case '.':
        return AcreType.openGround;
      case '|':
        return AcreType.trees;
      case '#':
        return AcreType.lumberyard;
    }
    throw Exception('Could not parse: $acre');
  }

  Forrest copy() => Forrest._(length, height, list.toList(growable: false));

  AcreType get(int x, int y) {
    final pos = _getPos(x, y);

    if ((x >= 0 && x < length) && (y >= 0 && y < height)) {
      return list[_getPos(x, y)];
    } else {
      return AcreType.openGround;
    }
  }

  void set(int x, int y, AcreType value) => list[_getPos(x, y)] = value;

  int _getPos(int x, int y) => x + (y * length);

  int countAcreTypeAround(int x, int y, AcreType acreType) {
    var count = 0;

    if (get(x - 1, y - 1) == acreType) {
      count++;
    }
    if (get(x, y - 1) == acreType) {
      count++;
    }
    if (get(x + 1, y - 1) == acreType) {
      count++;
    }
    if (get(x - 1, y) == acreType) {
      count++;
    }
    if (get(x + 1, y) == acreType) {
      count++;
    }
    if (get(x - 1, y + 1) == acreType) {
      count++;
    }
    if (get(x, y + 1) == acreType) {
      count++;
    }
    if (get(x + 1, y + 1) == acreType) {
      count++;
    }

    return count;
  }

  int get resourceValue {
    var trees = 0, lumberyards = 0;

    for (var acre in list) {
      if (acre == AcreType.trees) {
        trees++;
      } else if (acre == AcreType.lumberyard) {
        lumberyards++;
      }
    }

    return trees * lumberyards;
  }

  @override
  String toString() {
    final sb = StringBuffer();

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < length; x++) {
        switch (get(x, y)) {
          case AcreType.openGround:
            sb.write('.');
            break;
          case AcreType.trees:
            sb.write('|');
            break;
          case AcreType.lumberyard:
            sb.write('#');
            break;
        }
      }
      sb.writeln();
    }

    sb.writeln('===========================================================');

    return sb.toString();
  }
}

int solveA(List<String> lines) {
  var forrest = Forrest(lines);
  var nextForrest = forrest.copy();
  Forrest temp;

  for (var minute = 0; minute < 10; minute++) {
    for (var y = 0; y < forrest.height; y++) {
      for (var x = 0; x < forrest.length; x++) {
        final acreType = forrest.get(x, y);

        if (acreType == AcreType.openGround) {
          nextForrest.set(
              x,
              y,
              (forrest.countAcreTypeAround(x, y, AcreType.trees) >= 3)
                  ? AcreType.trees
                  : AcreType.openGround);
        } else if (acreType == AcreType.trees) {
          nextForrest.set(
              x,
              y,
              (forrest.countAcreTypeAround(x, y, AcreType.lumberyard) >= 3)
                  ? AcreType.lumberyard
                  : AcreType.trees);
        } else if (acreType == AcreType.lumberyard) {
          nextForrest.set(
              x,
              y,
              (forrest.countAcreTypeAround(x, y, AcreType.lumberyard) >= 1 &&
                      forrest.countAcreTypeAround(x, y, AcreType.trees) >= 1)
                  ? AcreType.lumberyard
                  : AcreType.openGround);
        } else {
          throw Exception('Should never happen!');
        }
      }
    }

    temp = forrest;
    forrest = nextForrest;
    nextForrest = temp;
  }

  return forrest.resourceValue;
}
