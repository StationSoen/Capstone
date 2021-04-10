import 'dart:math';
import 'package:collection/collection.dart';

import 'package:dart_test/dev_cube.dart';

void main(List<String> arguments) {
  print('Hello world: ${true}!\n');
  var a = Cube();
  var aCoordinate = a.example[0];
  var aDegree = a.example[1];
  var aOrder = a.example[2];

  a.type;
  print('$a');

  var b = Cube();
  print('$b');

  var c = Cube();
  print('$c');
}
