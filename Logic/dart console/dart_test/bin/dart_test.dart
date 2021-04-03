import 'dart:math';
import 'package:collection/collection.dart';

import 'package:dart_test/dev_cube.dart';

void main(List<String> arguments) {
  print('Hello world: ${true}!\n');
  var a = Cube();
  print(' ${Cube.devList(4, true)}');
  print(' ${Cube.devList(4, false)}');
}
