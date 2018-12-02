// --- Day 2: Inventory Management System ---
// https://adventofcode.com/2018/day/2

int solveA(List<String> input) {
  var twoTimes = 0;
  var threeTimes = 0;

  for (var word in input) {
    if (_containsLetterNumberOfTimes(word, 2)) {
      twoTimes++;
    }
    if (_containsLetterNumberOfTimes(word, 3)) {
      threeTimes++;
    }
  }

  return twoTimes * threeTimes;
}

bool _containsLetterNumberOfTimes(String word, int nTimes) {
  final map = <String, int>{};

  for (var i = 0; i < word.length; i++) {
    map.update(word[i], (count) => count + 1, ifAbsent: () => 1);
  }

  return map.containsValue(nTimes);
}

String solveB(List<String> input) {
  final sb = StringBuffer();

  for (var word1 in input) {
    for (var word2 in input) {
      if (word1 != word2 && _doWordsOnlyDifferByOneLetter(word1, word2)) {
        for (var i = 0; i < word1.length; i++) {
          if (word1[i] == word2[i]) {
            sb.write(word1[i]);
          }
        }
        return sb.toString();
      }
    }
  }
  throw Exception('Should never happen!');
}

bool _doWordsOnlyDifferByOneLetter(String word1, String word2) {
  var countDifferentLetters = 0;

  for (var i = 0; i < word1.length; i++) {
    if (word1[i] != word2[i] && ++countDifferentLetters > 1) {
      return false;
    }
  }

  return true;
}
