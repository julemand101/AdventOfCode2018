// --- Day 7: The Sum of Its Parts ---
// https://adventofcode.com/2018/day/7

import 'dart:collection';

class Step {
  final String id;
  final Set<Step> dependencies = Set();
  final Set<Step> stepsThereDependsOnThisStep = Set();

  Step(this.id);
}

final _exp = RegExp(r'Step (\w) must be finished before step (\w) can begin.');

String solveA(List<String> input) {
  // Ensure the keys are sorted alphabetical
  final cache = SplayTreeMap<String, Step>();

  for (var line in input) {
    final matches = _exp.firstMatch(line);
    final aId = matches.group(1);
    final bId = matches.group(2);

    final aStep = cache.putIfAbsent(aId, () => Step(aId));
    final bStep = cache.putIfAbsent(bId, () => Step(bId));

    bStep.dependencies.add(aStep);
    aStep.stepsThereDependsOnThisStep.add(bStep);
  }

  final steps = cache.values.toList();
  final sb = StringBuffer();

  while (steps.isNotEmpty) {
    final currentStep = steps.where((step) => step.dependencies.isEmpty).first;

    for (var step in currentStep.stepsThereDependsOnThisStep) {
      step.dependencies.remove(currentStep);
    }

    sb.write(currentStep.id);
    steps.remove(currentStep);
  }

  return sb.toString();
}
