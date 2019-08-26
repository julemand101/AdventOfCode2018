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

int solveA(List<String> lines) {
  final regEx = RegExp(r'(\w{4}) (\d+) (\d+) (\d+)');
  final codeLines = <CodeLine>[];
  final registers = List.generate(6, (_) => Register(0));
  Register ip;

  for (var line in lines) {
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

  while (ip.value >= 0 && ip.value < codeLines.length) {
    codeLines[ip.value].call(registers);
    ip.value++; // Update value after call since call can update the value
  }

  return registers[0].value;
}
