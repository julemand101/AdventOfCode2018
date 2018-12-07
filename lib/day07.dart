// --- Day 7: The Sum of Its Parts ---
// https://adventofcode.com/2018/day/7

import 'dart:collection';

class Step {
  final String id;
  final int time;
  final Set<Step> dependencies = Set();
  final Set<Step> stepsThereDependsOnThisStep = Set();

  Step(this.id) : time = id.codeUnitAt(0) - 64;
}

class Worker {
  final int extraTimeForWork;
  int time = 0;
  Step step;

  Worker(this.extraTimeForWork);

  void addStep(Step step) {
    this.step = step;
    time = step.time + extraTimeForWork;
  }

  bool tickForwardAndCheckIfDone() {
    if (step != null && --time == 0) {
      for (var stepThereDependsOnThisStep in step.stepsThereDependsOnThisStep) {
        stepThereDependsOnThisStep.dependencies.remove(step);
      }

      step = null;
    }

    return step == null && time == 0;
  }
}

String solveA(List<String> input) {
  final steps = _getSteps(input);
  final orderOfInstructions = StringBuffer();

  while (steps.isNotEmpty) {
    final currentStep = steps.where((step) => step.dependencies.isEmpty).first;

    for (var step in currentStep.stepsThereDependsOnThisStep) {
      step.dependencies.remove(currentStep);
    }

    orderOfInstructions.write(currentStep.id);
    steps.remove(currentStep);
  }

  return orderOfInstructions.toString();
}

int _stepCompare(Step step1, Step step2) => step1.id.compareTo(step2.id);

int solveB(List<String> input, int workers, int extraTimeForWork) {
  final steps = SplayTreeSet<Step>.from(_getSteps(input), _stepCompare);
  final allWorkers = List.generate(workers, (_) => Worker(extraTimeForWork));

  var time = 0;
  var idleWorkers = allWorkers.toList();

  while (steps.isNotEmpty || idleWorkers.length != workers) {
    final currentSteps =
        steps.where((step) => step.dependencies.isEmpty).toList();

    for (var step in currentSteps) {
      if (idleWorkers.isNotEmpty) {
        idleWorkers.removeLast().addStep(step);
        steps.remove(step);
      } else {
        break;
      }
    }

    // Check if any workers are done and get a list of idle workers
    idleWorkers = allWorkers
        .where((worker) => worker.tickForwardAndCheckIfDone())
        .toList();

    time++;
  }

  return time;
}

final _exp = RegExp(r'Step (\w) must be finished before step (\w) can begin.');

List<Step> _getSteps(List<String> input) {
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

  return cache.values.toList();
}
