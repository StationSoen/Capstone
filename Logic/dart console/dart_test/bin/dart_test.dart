import 'dart:convert';
import 'dart:math';
import 'package:collection/collection.dart';

import 'package:dart_test/dev_cube.dart';

void main(List<String> arguments) {
  for (var i = 0; i < 4; i++) {
    for (var j = 0; j < 1; j++) {
      var cube = DevCube(j, i);
      print('$cube');
    }
  }
}
