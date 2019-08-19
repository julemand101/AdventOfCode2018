typedef Instruction = void Function(
    List<Register> registers, int a, int b, int c);

class Register {
  int value;
  Register(this.value);
}

List<Instruction> instructions = List.unmodifiable([
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

void main() {
  final result = createRegisters(3, 2, 2, 1);
  var count = 0;

  for (var instruction in instructions) {
    final registers = createRegisters(3, 2, 1, 1);

    instruction(registers, 2, 1, 2);

    if (registersEqual(registers, result)) {
      count++;
    }
  }

  print(count);
}

bool registersEqual(List<Register> r1s, List<Register> r2s) {
  for (var i = 0; i < r1s.length; i++) {
    if (r1s[i].value != r2s[i].value) {
      return false;
    }
  }
  return true;
}

List<Register> createRegisters(int a, int b, int c, int d) =>
    List.unmodifiable([Register(a), Register(b), Register(c), Register(d)]);
