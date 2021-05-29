import 'package:flutter/material.dart';
import 'package:plp/exam.dart';
import 'package:plp/logic/stack_blocks.dart';
import 'dart:ui' as UI;

import 'blockpng.dart';

Future<List<Problem>> makeblockproblem(
  int num,
  int level,
  String directory,
  int counter,
) async {
  List<Problem> blockList = [];
  for (int i = 1; i <= num; i++) {
    var temp = StackBlocks(level: level);
    blockList.add(Problem(
        answer: temp.answer[0],
        problemType: 3,
        difficulty: temp.level,
        textType: temp.type));

    for (int j = 0; j < temp.example.length; j++) {
      await drawblockpng(
          'problem' + (i + counter).toString() + '_' + j.toString(),
          temp.example[j],
          directory);
    }

    for (int j = 0; j < temp.suggestion.length; j++) {
      await drawblockpng(
          'example' + (i + counter).toString() + '_' + j.toString(),
          temp.suggestion[j],
          directory);
    }

    //debugPrint(temp.example[1].toString());
    //debugPrint(temp.example[1].body[0][0][0].toString());
  }
  // debugPrint("문제번호는$i");
  // debugPrint("${temp.toString()}");

  debugPrint("로딩끝남");
  return blockList;
}
