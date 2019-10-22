// --- Day 19: Go With The Flow ---
// https://adventofcode.com/2018/day/19

class Register {
  int value;
  Register(this.value);

  @override
  String toString() => value.toString();
}

typedef Instruction = void Function(List<Register> r, int a, int b, int c);

Map<String, Instruction> instructions = Map.unmodifiable(<String, Instruction>{
  // Addition
  'addr': (r, a, b, c) => r[c].value = r[a].value + r[b].value,
  'addi': (r, a, b, c) => r[c].value = r[a].value + b,

  // Multiplication
  'mulr': (r, a, b, c) => r[c].value = r[a].value * r[b].value,
  'muli': (r, a, b, c) => r[c].value = r[a].value * b,

  // Bitwise AND
  'banr': (r, a, b, c) => r[c].value = r[a].value & r[b].value,
  'bani': (r, a, b, c) => r[c].value = r[a].value & b,

  // Bitwise OR
  'borr': (r, a, b, c) => r[c].value = r[a].value | r[b].value,
  'bori': (r, a, b, c) => r[c].value = r[a].value | b,

  // Assignment
  'setr': (r, a, b, c) => r[c].value = r[a].value,
  'seti': (r, a, b, c) => r[c].value = a,

  // Greater-than testing
  'gtir': (r, a, b, c) => r[c].value = (a > r[b].value) ? 1 : 0,
  'gtri': (r, a, b, c) => r[c].value = (r[a].value > b) ? 1 : 0,
  'gtrr': (r, a, b, c) => r[c].value = (r[a].value > r[b].value) ? 1 : 0,

  // Equality testing
  'eqir': (r, a, b, c) => r[c].value = (a == r[b].value) ? 1 : 0,
  'eqri': (r, a, b, c) => r[c].value = (r[a].value == b) ? 1 : 0,
  'eqrr': (r, a, b, c) => r[c].value = (r[a].value == r[b].value) ? 1 : 0,
});

class CodeLine {
  final String instructionName;
  final Instruction instruction;
  final int a, b, c;

  CodeLine(this.instructionName, this.a, this.b, this.c)
      : instruction = instructions[instructionName] {
    if (instruction == null) {
      throw Exception('Could not find implementation of $instructionName');
    }
  }

  void call(List<Register> r) => instruction(r, a, b, c);

  @override
  String toString() => '$instructionName $a $b $c';
}

int solve(List<String> lines, List<Register> registers, {bool example}) {
  final regEx = RegExp(r'(\w{4}) (\d+) (\d+) (\d+)');
  final codeLines = <CodeLine>[];
  Register ip;

  for (final line in lines) {
    if (line.startsWith('#')) {
      ip = registers[int.parse(line.split(' ')[1])];
    } else {
      final parsed = regEx.firstMatch(line);
      final instructionName = parsed.group(1);
      final a = int.parse(parsed.group(2));
      final b = int.parse(parsed.group(3));
      final c = int.parse(parsed.group(4));

      codeLines.add(CodeLine(instructionName, a, b, c));
    }
  }

  // Stop program after initial load of registers
  while (ip.value >= 0 &&
      ip.value < codeLines.length &&
      (example || ip.value != 1)) {
    codeLines[ip.value].call(registers);
    ip.value++; // Update value after call since call can update the value
  }

  if (!example) {
    // Find all divisors of number in registers[1] and combine them into [0].
    registers[0].value = 0;
    for (var i = 1; i <= registers[1].value; ++i) {
      if (registers[1].value % i == 0) {
        registers[0].value += i;
      }
    }
  }

  return registers[0].value;
}

int solveA(List<String> lines, {bool example = false}) =>
    solve(lines, List.generate(6, (_) => Register(0)), example: example);

int solveB(List<String> lines) =>
    solve(lines, List.generate(6, (_) => Register(0))..[0].value = 1,
        example: false);
