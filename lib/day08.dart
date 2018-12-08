// --- Day 8: Memory Maneuver ---
// https://adventofcode.com/2018/day/8

class Node {
  final List<Node> childNodes = [];
  final List<int> metadata = [];

  Node(List<int> input) {
    final quantityChildNodes = input.removeLast();
    final quantityMetadataEntries = input.removeLast();

    for (var i = 0; i < quantityChildNodes; i++) {
      childNodes.add(Node(input));
    }

    for (var i = 0; i < quantityMetadataEntries; i++) {
      metadata.add(input.removeLast());
    }
  }

  int get metaSum => metadata.fold(0, (sum, metadata) => sum + metadata);
  int get sum => childNodes.fold(metaSum, (sum, node) => sum + node.sum);

  int get value {
    if (childNodes.isEmpty) {
      return metaSum;
    } else {
      var sum = 0;

      for (var position in metadata) {
        if (position > 0 && position <= childNodes.length) {
          sum += childNodes[position - 1].value;
        }
      }

      return sum;
    }
  }
}

// The list is reversed for performance since we need to make a lot of pop
// operations at the end of the list (this operation is cheaper than removing
// the first element)
int solveA(List<int> input) => Node(input.reversed.toList()).sum;
int solveB(List<int> input) => Node(input.reversed.toList()).value;
