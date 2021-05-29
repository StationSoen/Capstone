import 'dart:convert';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:dart_test/dev_cube.dart';
import 'package:dart_test/hole_punch.dart';
import 'package:dart_test/paper_fold.dart';
import 'package:dart_test/stack_blocks.dart';

void main(List<String> arguments) {
  var a = Blocks(x: 2, y: 4, z: 3);
  var b = a.separate(3, Random());
  print(a);
  print(b[0]);
  StackBlocks();
}
