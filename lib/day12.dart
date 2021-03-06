// --- Day 12: Subterranean Sustainability ---
// https://adventofcode.com/2018/day/12

class Pot {
  final int id;
  bool containPlant;

  Pot(this.id, {this.containPlant = false});
}

class Rule {
  final List<bool> pattern;

  const Rule(this.pattern);

  bool match(List<Pot> pots) {
    for (var i = 0; i < pots.length; i++) {
      if (pots[i].containPlant != pattern[i]) {
        return false;
      }
    }
    return true;
  }
}

int solveA(List<String> input, {int generation = 20}) {
  var pots = <Pot>[];

  final stateString = input.first.substring('initial state: '.length);
  for (var i = 0; i < stateString.length; i++) {
    pots.add(Pot(i, containPlant: stateString[i] == '#'));
  }

  final rules = <Rule>[];
  for (final line in input.skip(2)) {
    if (line.endsWith('#')) {
      final pattern = line.split(' => ')[0].codeUnits.map((c) => c == 35);
      rules.add(Rule(pattern.toList(growable: false)));
    }
  }

  for (var i = 0; i < generation; i++) {
    // Check if we need more pots on the left side and add them
    if (pots[0].containPlant) {
      pots.insert(0, Pot(pots[0].id - 1));
    }
    if (pots[1].containPlant) {
      pots.insert(0, Pot(pots[0].id - 1));
    }
    if (pots[2].containPlant) {
      pots.insert(0, Pot(pots[0].id - 1));
    }

    // Check if we need more pots on the right side and add them
    if (pots.last.containPlant) {
      pots.add(Pot(pots.last.id + 1));
    }
    if (pots[pots.length - 2].containPlant) {
      pots.add(Pot(pots.last.id + 1));
    }
    if (pots[pots.length - 3].containPlant) {
      pots.add(Pot(pots.last.id + 1));
    }

    // Begin pattern matching and building next list of pots
    final nextGenerationPots = <Pot>[];
    for (var i = 2; i < pots.length - 2; i++) {
      final potsToMatch = pots.sublist(i - 2, i + 3);

      var containPlant = false;
      for (final rule in rules) {
        if (rule.match(potsToMatch)) {
          containPlant = true;
          break;
        }
      }
      nextGenerationPots.add(Pot(pots[i].id, containPlant: containPlant));
    }

    pots = nextGenerationPots;
  }

  // Sum of the numbers of all pots which contain a plant
  return pots.fold(0, (sum, pot) => pot.containPlant ? sum + pot.id : sum);
}

int solveB(List<String> input) {
  // By running the simulation long enough we got to see that the difference
  // between each run are going to be stable. In my case, this was already
  // happen with the 100th generation.
  //
  // So by using that knowledge we can just calculate the 50000000000th
  // generation instead of simulating each generation.
  final a = solveA(input, generation: 100);
  final b = solveA(input, generation: 101);

  return a + ((50000000000 - 100) * (b - a));
}
