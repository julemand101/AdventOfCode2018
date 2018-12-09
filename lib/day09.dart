// --- Day 9: Marble Mania ---
// https://adventofcode.com/2018/day/9

import 'dart:math';

int solve(int numberOfPlayers, int lastMarbleWorth) {
  final playerScores = _getInitialPlayerScores(numberOfPlayers);
  final circle = [0];
  var currentMarblePosition = 0;
  var currentPlayer = 0;

  for (var marbleWorth = 1; marbleWorth <= lastMarbleWorth; marbleWorth++) {
    currentPlayer = _nextPlayer(currentPlayer, numberOfPlayers);

    if (marbleWorth % 23 == 0) {
      playerScores[currentPlayer] += marbleWorth;
      currentMarblePosition = _nextPosition(currentMarblePosition, circle, -8);
      playerScores[currentPlayer] += circle.removeAt(currentMarblePosition);
    } else {
      currentMarblePosition = _nextPosition(currentMarblePosition, circle);
      circle.insert(currentMarblePosition, marbleWorth);
    }
  }

  return playerScores.values.fold(0, max);
}

Map<int, int> _getInitialPlayerScores(int numberOfPlayers) {
  final playerScores = <int, int>{};

  for (var i = 1; i <= numberOfPlayers; i++) {
    playerScores[i] = 0;
  }

  return playerScores;
}

int _nextPlayer(int currentPlayer, int numberOfPlayers) =>
    (currentPlayer == numberOfPlayers) ? 1 : currentPlayer + 1;

int _nextPosition(int currentMarblePosition, List circle, [int skip = 1]) =>
    ((currentMarblePosition + skip) % circle.length) + 1;
