// --- Day 1: Inverse Captcha ---
// https://adventofcode.com/2017/day/1

typedef Tester = bool Function(String input, int pos);

int solveA(String input) => _solve(input, _testA);

int solveB(String input) => _solve(input, _testB);

int _solve(String input, Tester test) {
  var sum = 0;

  for (var i = 0; i < input.length; i++) {
    if (test(input, i)) {
      sum += int.parse(input[i]);
    }
  }

  return sum;
}

bool _testA(String input, int pos) =>
    input[pos] == input[(pos + 1) % input.length];

bool _testB(String input, int pos) =>
    input[pos] == input[(pos + (input.length ~/ 2)) % input.length];
