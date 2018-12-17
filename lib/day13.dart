// --- Day 13: Mine Cart Madness ---
// https://adventofcode.com/2018/day/13

enum Direction { up, down, left, right }
enum TurnDirection { left, straight, right }

class Cart {
  int x, y;
  Direction direction;
  TurnDirection turnDirection = TurnDirection.left;

  Cart(this.x, this.y, this.direction);

  static List<Cart> getCartsFromMap(List<String> map) {
    final carts = <Cart>[];

    // Find carts in map
    for (var y = 0; y < map.length; y++) {
      for (var x = 0; x < map[y].length; x++) {
        switch (map[y][x]) {
          case '^':
            carts.add(Cart(x, y, Direction.up));
            map[y] = map[y].replaceFirst('^', '|');
            break;
          case 'v':
            carts.add(Cart(x, y, Direction.down));
            map[y] = map[y].replaceFirst('v', '|');
            break;
          case '<':
            carts.add(Cart(x, y, Direction.left));
            map[y] = map[y].replaceFirst('<', '-');
            break;
          case '>':
            carts.add(Cart(x, y, Direction.right));
            map[y] = map[y].replaceFirst('>', '-');
            break;
        }
      }
    }

    return carts;
  }

  void tick(List<String> map) {
    final currentPosition = map[y][x];

    switch (currentPosition) {
      case '+':
        switch (turnDirection) {
          case TurnDirection.left:
            turnDirection = TurnDirection.straight;

            switch (direction) {
              case Direction.up:
                direction = Direction.left;
                break;
              case Direction.down:
                direction = Direction.right;
                break;
              case Direction.left:
                direction = Direction.down;
                break;
              case Direction.right:
                direction = Direction.up;
                break;
            }
            break;

          case TurnDirection.straight:
            turnDirection = TurnDirection.right;
            break;

          case TurnDirection.right:
            turnDirection = TurnDirection.left;

            switch (direction) {
              case Direction.up:
                direction = Direction.right;
                break;
              case Direction.down:
                direction = Direction.left;
                break;
              case Direction.left:
                direction = Direction.up;
                break;
              case Direction.right:
                direction = Direction.down;
                break;
            }
            break;
        }
        break;
      case r'/':
        switch (direction) {
          case Direction.up:
            direction = Direction.right;
            break;

          case Direction.down:
            direction = Direction.left;
            break;

          case Direction.left:
            direction = Direction.down;
            break;

          case Direction.right:
            direction = Direction.up;
            break;
        }
        break;
      case r'\':
        switch (direction) {
          case Direction.up:
            direction = Direction.left;
            break;

          case Direction.down:
            direction = Direction.right;
            break;

          case Direction.left:
            direction = Direction.up;
            break;

          case Direction.right:
            direction = Direction.down;
            break;
        }
        break;
      case r'-':
      case r'|':
        break;
      default:
        throw Exception('Should never happen!');
    }

    // Move the cart
    switch (direction) {
      case Direction.up:
        y -= 1;
        break;

      case Direction.down:
        y += 1;
        break;

      case Direction.left:
        x -= 1;
        break;

      case Direction.right:
        x += 1;
        break;
    }
  }

  bool isColliding(Cart cart) => x == cart.x && y == cart.y;

  @override
  String toString() => '$y,$x : $direction';
}

String solveA(List<String> input) {
  final map = input.toList(growable: false);
  final carts = Cart.getCartsFromMap(map);

  const runForeverUntilCollision = true;
  while (runForeverUntilCollision) {
    carts.sort((a, b) {
      final compareY = a.y.compareTo(b.y);

      if (compareY == 0) {
        return a.x.compareTo(b.x);
      } else {
        return compareY;
      }
    });

    for (var cart in carts) {
      cart.tick(map);
      if (carts
          .where((otherCart) => !identical(cart, otherCart))
          .any((otherCart) => cart.isColliding(otherCart))) {
        return '${cart.x},${cart.y}';
      }
    }
  }

  return null;
}

String solveB(List<String> input) {
  final map = input.toList(growable: false);
  final carts = Cart.getCartsFromMap(map);

  while (carts.length > 1) {
    carts.sort((a, b) {
      final compareY = a.y.compareTo(b.y);

      if (compareY == 0) {
        return a.x.compareTo(b.x);
      } else {
        return compareY;
      }
    });

    final cartsToBeRemoved = [];

    for (var cart in carts) {
      cart.tick(map);

      for (var otherCart in carts.where((c) => !identical(cart, c))) {
        if (cart.isColliding(otherCart)) {
          cartsToBeRemoved..add(cart)..add(otherCart);
        }
      }
    }

    cartsToBeRemoved.forEach(carts.remove);
  }

  final lastCart = carts.first;
  return '${lastCart.x},${lastCart.y}';
}
