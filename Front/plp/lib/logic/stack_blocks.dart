import 'dart:convert';
import 'dart:math';

///

/// 3d 블럭쌓기
class StackBlocks {
  /// 난이도
  var level;

  /// 문제 유형
  var type;

  var example;
  var suggestion;
  var answer;

  var seed;
  late Random rng;

  static Random seedRng = Random();

  /// * example[0] :
  StackBlocks({this.level = 0, this.type, this.seed}) {
    print('=================BLOCKS START=================');
    print('level : $level\n');

    seed ??= seedRng.nextInt(2147483647);
    rng = Random(seed);
    print('seed : $seed\n');

    type ??= rng.nextInt(1);
    print('type : $type\n');

    // generate with leveling
    var bigOne =
        (level == 2) ? Blocks(x: 3, y: 4, z: 3) : Blocks(x: 2, y: 4, z: 3);
    var blocks = (level == 0)
        ? bigOne.separate(2, Random())
        : bigOne.separate(3, Random());
    //var choose = rng.nextInt(blocks.length);
    var choose = 0;

    // example
    example = [bigOne];
    for (var i = 0; i < blocks.length; i++) {
      if (i != choose) example.add(blocks[i]);
    }

    for (var i = 1; i < example.length; i++) {
      example[i].turn(rng.nextInt(3), rng.nextInt(2) > 0);
    }
    print('example: $example');

    //answer
    answer = [0];
    //answer = [rng.nextInt(4)];
    print('answer: $answer');

    // suggestion
    suggestion = [];
    do {
      var wrong = blocks[choose].clone();
      wrong.shrink(choose + 1, rng);
      wrong.expand(choose + 1, rng);
      if (!wrong.isEqual(blocks[choose])) {
        var check = true;
        for (var i = 0; i < suggestion.length; i++) {
          if (wrong.isEqual(suggestion[i])) check = false;
        }
        if (check) suggestion.add(wrong);
      }
    } while (suggestion.length < 3);
    suggestion.insert(answer[0], blocks[choose]);

    for (var i = 0; i < suggestion.length; i++) {
      suggestion[i].turn(rng.nextInt(3), rng.nextInt(2) > 0);
    }

    print('suggestion: $suggestion');
  }

  @override
  String toString() {
    return '';
  }
}

/// x*y*z
class Blocks {
  var x, y, z;
  var body;

  Blocks clone() {
    var newBlock = Blocks(x: x, y: y, z: z);

    for (var a = 0; a < x; a++) {
      for (var b = 0; b < y; b++) {
        for (var c = 0; c < z; c++) {
          newBlock.body[a][b][c] = body[a][b][c];
        }
      }
    }

    return newBlock;
  }

  void turn(int axis, bool direction) {
    if (axis == 0) {
      var temp = y;
      y = z;
      z = temp;
    } else if (axis == 1) {
      var temp = z;
      z = x;
      x = temp;
    } else if (axis == 2) {
      var temp = x;
      x = y;
      y = temp;
    }

    var newBody = List.generate(
        x, (i) => List.generate(y, (i) => List.generate(z, (i) => 0)));

    for (var a = 0; a < x; a++) {
      for (var b = 0; b < y; b++) {
        for (var c = 0; c < z; c++) {
          if (axis == 0 && direction) {
            newBody[a][b][c] = body[a][z - c - 1][b];
          } else if (axis == 0 && !direction) {
            newBody[a][b][c] = body[a][c][y - b - 1];
          }
          //
          else if (axis == 1 && direction) {
            newBody[a][b][c] = body[z - c - 1][b][a];
          } else if (axis == 1 && !direction) {
            newBody[a][b][c] = body[c][b][x - a - 1];
          }
          //
          else if (axis == 2 && direction) {
            newBody[a][b][c] = body[y - b - 1][a][c];
          } else if (axis == 2 && !direction) {
            newBody[a][b][c] = body[b][x - a - 1][c];
          }
        }
      }
    }
    body = newBody;
  }

  bool isEqual(Blocks blocks) {
    for (var a = 0; a < x; a++) {
      for (var b = 0; b < y; b++) {
        for (var c = 0; c < z; c++) {
          if (blocks.body[a][b][c] != body[a][b][c]) return false;
        }
      }
    }

    return true;
  }

  int checkAdj(List point, int type) {
    var count = 0;
    var a = point[0];
    var b = point[1];
    var c = point[2];

    if (a + 1 < x && body[a + 1][b][c] == type) count++;
    if (a > 0 && body[a - 1][b][c] == type) count++;
    if (b + 1 < y && body[a][b + 1][c] == type) count++;
    if (b > 0 && body[a][b - 1][c] == type) count++;
    if (c + 1 < z && body[a][b][c + 1] == type) count++;
    if (c > 0 && body[a][b][c - 1] == type) count++;

    return count;
  }

  /// Expand block colored with (type).
  bool expand(int type, Random rng) {
    var points = [];
    for (var i = 0; i < x; i++) {
      for (var j = 0; j < y; j++) {
        for (var k = 0; k < z; k++) {
          if (body[i][j][k] == 0 && checkAdj([i, j, k], type) > 0) {
            points.add([i, j, k]);
          }
        }
      }
    }
    if (points.isNotEmpty) {
      var p = points[rng.nextInt(points.length)];
      body[p[0]][p[1]][p[2]] = type;
      return true;
    } else {
      return false;
    }
  }

  /// randomly remove one of the blocks.
  bool shrink(int type, Random rng) {
    var points = [];
    for (var a = 0; a < x; a++) {
      for (var b = 0; b < y; b++) {
        for (var c = 0; c < z; c++) {
          if (body[a][b][c] != 0) points.add([a, b, c]);
        }
      }
    }
    if (points.isNotEmpty) {
      var p = points[rng.nextInt(points.length)];
      body[p[0]][p[1]][p[2]] = 0;
      return true;
    } else {
      return false;
    }
  }

  /// separate body into new Blocks with count (number),
  /// with percentage of (ratio), use random obj (rng).
  List separate(int number, Random rng) {
    var newBlocks = List.generate(number, (index) => Blocks(x: x, y: y, z: z));

    switch (number) {
      case 3:
        body[0][0][0] = 1;
        body[x - 1][y - 1][0] = 2;
        body[0][y - 1][z - 1] = 3;
        break;
      default:
        body[0][0][0] = 1;
        body[x - 1][y - 1][z - 1] = 2;
        break;
    }

    while (true) {
      var check = false;
      for (var i = 0; i < number; i++) {
        check = check | expand(i + 1, rng);
      }
      if (!check) break;
    }

    for (var i = 0; i < number; i++) {
      for (var a = 0; a < x; a++) {
        for (var b = 0; b < y; b++) {
          for (var c = 0; c < z; c++) {
            if (body[a][b][c] == i + 1) newBlocks[i].body[a][b][c] = i + 1;
          }
        }
      }
    }
    return newBlocks;
  }

  Blocks({required this.x, required this.y, required this.z}) {
    /// Create empty list filled with zero.
    body = List.generate(
        x, (i) => List.generate(y, (i) => List.generate(z, (i) => 0)));
  }

  @override
  String toString() {
    var result = '($x, $y, $z):\n';
    for (var i = 0; i < x; i++) {
      for (var j = 0; j < y; j++) {
        result += body[i][j].toString();
      }
      result += '\n';
    }
    return result;
  }
}
