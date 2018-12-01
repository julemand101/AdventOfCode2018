// --- Day 1: Chronal Calibration ---
// https://adventofcode.com/2018/day/1

int solveA(List<String> input) =>
    input.map(int.parse).fold(0, (prev, value) => prev + value);

int solveB(List<String> input) {
  final parsedList = input.map(int.parse).toList();
  final memory = Set();
  var frequency = 0;

  for (var i = 0; memory.add(frequency); i = (i + 1) % parsedList.length) {
    frequency += parsedList[i];
  }

  return frequency;
}
