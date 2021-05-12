import 'dart:convert';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:dart_test/dev_cube.dart';
import 'package:dart_test/paper_fold.dart';

void main(List<String> arguments) {
  // for (var i = 0; i < 4; i++) {
  //   for (var j = 0; j < 3; j++) {
  //     var cube = DevCube(j, i);
  //     print('$cube');
  //   }
  // }

  // var a = PaperFold(0, 0);
  // print('$a');
  // var b = PaperFold(0, 0);
  // print('$b');

  //print(linearSymmerty(point: [0, -0.5], line: [2, 1, 2]));

  // print(DevCube(0, 0, 0));
  // print(DevCube(0, 0));
  // print(DevCube(0, 0));
  // print(DevCube(0, 0, 0));
  // print(DevCube(0, 0));
  // print(DevCube(0, 0));

  List<dynamic> a;

  a = [
    [
      [0, 1],
      [1, 2]
    ],
    [
      [1, 1],
      [3, 4]
    ]
  ];
  var b = [
    [
      [0, 1],
      [1, 2]
    ],
    [
      [1, 1],
      [3, 4]
    ]
  ];

  // print(a);
  // a.add(json.decode(json.encode(a[0])));
  // print(a);
  // a[2][0][0] = 1000;
  // print(a);
  // print(a[0][0][1] == a[0][1][1]);

  // pointLine(intersection(
  //     line1: pointToLine(point1: [0.5, 1], point2: [0, 2]),
  //     line2: pointToLine(point1: [0, 0], point2: [1, 1])));

  // print(foldLayer([
  //   [0, 0],
  //   [100, 0],
  //   [100, 100],
  //   [0, 100]
  // ], [
  //   1,
  //   0,
  //   50
  // ], true));
  // print(foldLayer([
  //   [0, 0],
  //   [100, 0],
  //   [100, 100],
  //   [0, 100]
  // ], [
  //   1,
  //   0,
  //   50
  // ], false));

  // var p = Paper();
  // print(p);
  // print(p.isCrossed([1, -1, 0]));

  // p.foldPaper([1, -1, 0], true, true);
  // print(p);
  // print(p.isCrossed([1, -1, 0]));

  // p.foldPaper([0, 1, 30], true, false);
  // print(p);
  // print(p.isIn([25, 55]));

  // p.foldPaper([1, 0, 70], false, false);
  // print(p);

  // var seedRng = Random();
  // int one = 0;
  // int zero = 0;
  // for (var i = 0; i < 10000; i++) {
  //   var n = seedRng.nextInt(2);
  //   if (n == 0) zero++;
  //   if (n == 1) one++;
  // }
  // print('one : $one, zero : $zero');

  //print(PaperFold.rangeEdge([0, 1, 50]));
  var p = PaperFold(0, 0, 1981623965);
  print(p);
}
