// --- Day 14: Chocolate Charts ---
// https://adventofcode.com/2018/day/14

String solveA(int input) {
  var elf1 = 0;
  var elf2 = 1;
  final memory = <int>[3, 7];

  while (memory.length < input + 1000) {
    memory.addAll(_getDigits(memory[elf1] + memory[elf2]));
    elf1 = (elf1 + 1 + memory[elf1]) % memory.length;
    elf2 = (elf2 + 1 + memory[elf2]) % memory.length;
  }

  final sb = StringBuffer();
  memory.getRange(input, input + 10).forEach(sb.write);

  return sb.toString();
}

int solveB(List<int> input) {
  var elf1 = 0;
  var elf2 = 1;
  var equalCount = 0;
  final memory = <int>[3, 7];

  for (var i = 0; i < 100000000; i++) {
    final digits = _getDigits(memory[elf1] + memory[elf2]);
    var digitUsed = 0;

    for (var digit in digits) {
      if (digit == input[equalCount]) {
        digitUsed++;
        if (++equalCount == input.length) {
          return memory.length + digitUsed - input.length;
        }
      } else {
        if (equalCount > 0) {
          equalCount = 0;

          if (digit == input[equalCount]) {
            equalCount++;
          }
        }
      }
    }

    memory.addAll(digits);
    elf1 = (elf1 + 1 + memory[elf1]) % memory.length;
    elf2 = (elf2 + 1 + memory[elf2]) % memory.length;
  }

  return -1;
}

Iterable<int> _getDigits(int input) {
  final list = <int>[];
  var number = input;

  if (number == 0) {
    list.add(0);
  } else {
    while (number > 0) {
      list.add(number % 10);
      number = number ~/ 10;
    }
  }

  return list.reversed;
}
