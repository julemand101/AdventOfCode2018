// --- Day 4: Repose Record ---
// https://adventofcode.com/2018/day/4

class Guard {
  final int id;

  // Key = minute, value = how often the guard sleeps on this minute
  final Map<int, int> sleepMap = {};

  Guard(this.id);

  DateTime? _startSleepTime;

  void beginSleep(DateTime time) {
    if (_startSleepTime == null) {
      _startSleepTime = time;
    } else {
      throw Exception('Should never happen!');
    }
  }

  void endSleep(DateTime endSleepTime) {
    for (var i = _startSleepTime!.minute; i < endSleepTime.minute; i++) {
      sleepMap.update(i, (i) => i + 1, ifAbsent: () => 1);
    }
    _startSleepTime = null;
  }

  int get sleepSum => sleepMap.values.fold(0, (p, e) => p + e);

  int get mostSleepyMinute {
    var maxValue = 0;
    var maxMinute = 0;

    sleepMap.forEach((minute, value) {
      if (value > maxValue) {
        maxMinute = minute;
        maxValue = value;
      }
    });

    return maxMinute;
  }
}

int solveA(List<String> input) {
  final guards = _parseInput(input);
  final mostSleepyGuard =
      guards.reduce((g1, g2) => g1.sleepSum > g2.sleepSum ? g1 : g2);

  return mostSleepyGuard.id * mostSleepyGuard.mostSleepyMinute;
}

int solveB(List<String> input) {
  final guards = _parseInput(input);

  late Guard maxGuard;
  var maxSleep = 0;
  var maxMinute = 0;

  // Scan each possible minute
  for (var i = 0; i < 60; i++) {
    for (final guard in guards) {
      final howOftenTheGuardSleepOnThisMinute = guard.sleepMap[i] ?? 0;

      if (howOftenTheGuardSleepOnThisMinute > maxSleep) {
        maxSleep = howOftenTheGuardSleepOnThisMinute;
        maxGuard = guard;
        maxMinute = i;
      }
    }
  }

  return maxGuard.id * maxMinute;
}

Iterable<Guard> _parseInput(List<String> input) {
  final sortedInput = input.toList(growable: false)
    ..sort((line1, line2) => _getTime(line1).compareTo(_getTime(line2)));

  final exp = RegExp(r'#([0-9]+)');
  final guardMap = <int, Guard>{};
  late Guard currentGuard;

  for (final line in sortedInput) {
    if (line.contains('Guard')) {
      final id = int.parse(exp.firstMatch(line)!.group(1)!);
      currentGuard = guardMap.putIfAbsent(id, () => Guard(id));
    } else if (line.endsWith('falls asleep')) {
      currentGuard.beginSleep(_getTime(line));
    } else if (line.endsWith('wakes up')) {
      currentGuard.endSleep(_getTime(line));
    }
  }

  return guardMap.values;
}

// [1518-11-01 00:00] Guard #10 begins shift
Map<String, DateTime> _cache = {};
DateTime _getTime(String line) =>
    _cache.putIfAbsent(line, () => DateTime.parse(line.substring(1, 17)));
