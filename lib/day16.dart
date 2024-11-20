// --- Day 16: Chronal Classification ---
// https://adventofcode.com/2018/day/16

typedef Instruction = void Function(
    List<Register> registers, int a, int b, int c);

class Register {
  int value;
  Register(this.value);

  @override
  String toString() => value.toString();

  Register clone() => Register(value);
}

class Sample {
  late List<Register> before;
  late List<Register> after;
  late ProgramInstruction programInstruction;

  static final RegExp _before = RegExp(r'Before: \[(\d), (\d), (\d), (\d)]');
  static final RegExp _after = RegExp(r'After: {2}\[(\d), (\d), (\d), (\d)]');

  Sample(List<String> lines) {
    if (lines.length != 3) {
      throw Exception('Did not get 3 lines!');
    }

    final beforeMatches = _before.allMatches(lines[0]).first;
    before = createRegisters(
        int.parse(beforeMatches.group(1)!),
        int.parse(beforeMatches.group(2)!),
        int.parse(beforeMatches.group(3)!),
        int.parse(beforeMatches.group(4)!));

    programInstruction = ProgramInstruction(lines[1]);

    final afterMatches = _after.allMatches(lines[2]).first;
    after = createRegisters(
        int.parse(afterMatches.group(1)!),
        int.parse(afterMatches.group(2)!),
        int.parse(afterMatches.group(3)!),
        int.parse(afterMatches.group(4)!));
  }
}

class ProgramInstruction {
  late int op, a, b, c;

  static final RegExp _instruction = RegExp(r'(\d+) (\d) (\d) (\d)');

  ProgramInstruction(String line) {
    final instructionMatches = _instruction.allMatches(line).first;
    op = int.parse(instructionMatches.group(1)!);
    a = int.parse(instructionMatches.group(2)!);
    b = int.parse(instructionMatches.group(3)!);
    c = int.parse(instructionMatches.group(4)!);
  }

  void call(List<Register> registers, Instruction instruction) {
    instruction(registers, a, b, c);
  }
}

List<Instruction> instructions = List.unmodifiable(<Instruction>[
  // Addition
  // - addr
  (r, a, b, c) => r[c].value = r[a].value + r[b].value,
  // - addi
  (r, a, b, c) => r[c].value = r[a].value + b,

  // Multiplication
  // - mulr
  (r, a, b, c) => r[c].value = r[a].value * r[b].value,
  // - muli
  (r, a, b, c) => r[c].value = r[a].value * b,

  // Bitwise AND
  // - banr
  (r, a, b, c) => r[c].value = r[a].value & r[b].value,
  // - bani
  (r, a, b, c) => r[c].value = r[a].value & b,

  // Bitwise OR
  // - borr
  (r, a, b, c) => r[c].value = r[a].value | r[b].value,
  // - bori
  (r, a, b, c) => r[c].value = r[a].value | b,

  // Assignment
  // - setr
  (r, a, b, c) => r[c].value = r[a].value,
  // - seti
  (r, a, b, c) => r[c].value = a,

  // Greater-than testing
  // - gtir
  (r, a, b, c) => r[c].value = (a > r[b].value) ? 1 : 0,
  // - gtri
  (r, a, b, c) => r[c].value = (r[a].value > b) ? 1 : 0,
  // - gtrr
  (r, a, b, c) => r[c].value = (r[a].value > r[b].value) ? 1 : 0,

  // Equality testing
  // - eqir
  (r, a, b, c) => r[c].value = (a == r[b].value) ? 1 : 0,
  // - eqri
  (r, a, b, c) => r[c].value = (r[a].value == b) ? 1 : 0,
  // - eqrr
  (r, a, b, c) => r[c].value = (r[a].value == r[b].value) ? 1 : 0,
]);

int solveA(List<String> input) {
  final samples = <Sample>[];

  for (var i = 0; i < input.length; i++) {
    final currentLine = input[i];

    if (currentLine.startsWith('Before:')) {
      samples.add(Sample(input.sublist(i, i + 3)));
      i += 2;
    }
  }

  var result = 0;

  for (final sample in samples) {
    var count = 0;

    for (final instruction in instructions) {
      final registers = cloneRegisters(sample.before);

      sample.programInstruction.call(registers, instruction);

      if (registersEqual(registers, sample.after)) {
        if (++count == 3) {
          result++;
          break;
        }
      }
    }
  }

  return result;
}

int solveB(List<String> input) {
  final samples = <Sample>[];
  final programInstructions = <ProgramInstruction>[];

  for (var i = 0; i < input.length; i++) {
    final currentLine = input[i];

    if (currentLine.startsWith('Before:')) {
      samples.add(Sample(input.sublist(i, i + 3)));
      i += 2;
    } else if (ProgramInstruction._instruction.hasMatch(currentLine)) {
      programInstructions.add(ProgramInstruction(currentLine));
    }
  }

  final opCodeMap = <int, List<Instruction>>{};

  for (final s in samples) {
    opCodeMap.putIfAbsent(s.programInstruction.op, () => instructions.toList());
  }

  for (final sample in samples) {
    final opCode = sample.programInstruction.op;

    for (final instruction in opCodeMap[opCode]!.toList()) {
      final registers = cloneRegisters(sample.before);

      sample.programInstruction.call(registers, instruction);

      if (!registersEqual(registers, sample.after)) {
        opCodeMap[opCode]!.remove(instruction);
      }
    }
  }

  while (opCodeMap.values.any((list) => list.length != 1)) {
    for (final opCode1 in opCodeMap.keys) {
      if (opCodeMap[opCode1]!.length == 1) {
        final instructionToDelete = opCodeMap[opCode1]!.first;

        for (final opCode2 in opCodeMap.keys.where((k) => k != opCode1)) {
          opCodeMap[opCode2]!.remove(instructionToDelete);
        }
      }
    }
  }

  final opCodeToInstruction =
      opCodeMap.map((opCode, list) => MapEntry(opCode, list.first));

  final registers = createRegisters(0, 0, 0, 0);

  for (final programInstruction in programInstructions) {
    programInstruction.call(
        registers, opCodeToInstruction[programInstruction.op]!);
  }

  return registers[0].value;
}

bool registersEqual(List<Register> r1s, List<Register> r2s) {
  for (var i = 0; i < r1s.length; i++) {
    if (r1s[i].value != r2s[i].value) {
      return false;
    }
  }
  return true;
}

List<Register> createRegisters(int a, int b, int c, int d) => List.unmodifiable(
    <Register>[Register(a), Register(b), Register(c), Register(d)]);

List<Register> cloneRegisters(List<Register> registers) =>
    List.unmodifiable(registers.map<Register>((register) => register.clone()));
