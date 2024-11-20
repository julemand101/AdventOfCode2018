// --- Day 9: Marble Mania ---
// https://adventofcode.com/2018/day/9

import 'dart:math';

class Marble {
  final int value;

  Marble? prev;
  Marble? next;

  Marble(this.value);

  void addNext(Marble marble) {
    marble
      ..prev = this
      ..next = next;

    next!.prev = marble;
    next = marble;
  }

  void addPrev(Marble marble) {
    marble
      ..next = this
      ..prev = prev;

    prev!.next = marble;
    prev = marble;
  }

  int unlinkAndReturnValue() {
    prev!.next = next;
    next!.prev = prev;
    prev = null;
    next = null;
    return value;
  }

  Marble getElementAt(int pos) {
    if (pos < 0) {
      return prev!.getElementAt(pos + 1);
    } else if (pos > 0) {
      return next!.getElementAt(pos - 1);
    }
    return this;
  }
}

int solve(int numberOfPlayers, int lastMarbleWorth) {
  final playerScores = _getInitialPlayerScores(numberOfPlayers);

  var currentMarble = Marble(0);
  currentMarble
    ..prev = currentMarble
    ..next = currentMarble;

  for (var marbleWorth = 1; marbleWorth <= lastMarbleWorth; marbleWorth++) {
    final currentPlayer = marbleWorth % numberOfPlayers;

    if (marbleWorth % 23 == 0) {
      playerScores.update(currentPlayer, (score) => score + marbleWorth);
      currentMarble = currentMarble.getElementAt(-7);
      playerScores.update(currentPlayer,
          (score) => score + currentMarble.next!.unlinkAndReturnValue());
    } else {
      currentMarble = currentMarble.getElementAt(2)
        ..addNext(Marble(marbleWorth));
    }
  }

  return playerScores.values.fold(0, max);
}

Map<int, int> _getInitialPlayerScores(int numberOfPlayers) {
  final playerScores = <int, int>{};

  for (var i = 0; i < numberOfPlayers; i++) {
    playerScores[i] = 0;
  }

  return playerScores;
}
