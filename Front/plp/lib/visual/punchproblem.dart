import 'package:flutter/material.dart';
import 'dart:ui' as UI;
import 'dart:ui';

import '../exam.dart';
import '../main.dart';
import 'punch_png.dart';
import 'load.dart';
import '../logic/hole_punch.dart';

Future<List<Problem>> makepunchproblem(
  int num,
  int level,
  String directory,
  int counter,
) async {
  List<Problem> punchList = [];
  for (int i = 1; i <= num; i++) {
    var temp = HolePunch(level: level);
    punchList.add(Problem(
        answer: temp.answer[0],
        problemType: 2,
        difficulty: temp.level,
        textType: 0));

    debugPrint('${i}번 문제${temp.toString()}');
    //debugPrint(temp.example[0][1].toString());
    //debugPrint(temp.example[0][1].layerCount.toString());
    //debugPrint(temp.example[0][1].layers.toString());

    //debugPrint(temp.example[1][1].toString());
    for (int j = 0; j < 4; j++) {
      //debugPrint(temp.example[0][j].toString());
      //debugPrint(temp.example[1][j].toString());
      if (j == 3) {
        //점을 그려야됨
        await drawpunchpng('problem' + (i + counter).toString() + '_' + j.toString(),
            temp.example[0][j], temp.example[2][j], true, directory);
      } else {
        //선을 그려야됨
        await drawpunchpng('problem' + (i + counter).toString() + '_' + j.toString(),
            temp.example[0][j], temp.example[1][j], false, directory);
      }
    }
    for (int j = 0; j < 4; j++) {
      await drawpunchsuggestionpng(
          'example' + (i + counter).toString() + '_' + j.toString(),
          temp.suggestion[j],
          directory);
    }

    for (int j = 0; j < 4; j++) {
      // debugPrint(temp.suggestion[j].toString());
      // debugPrint(temp.suggestion[j].layerCount.toString());
      if (j == 3) {
        await drawpunchpng(
            'back' + (i + counter).toString() + '_' + j.toString(),
            temp.example[0][j],
            temp.example[2][j],
            true,
            directory);
      } else {
        await drawpunchnotepng(
            'back' + (i + counter).toString() + '_' + j.toString(),
            temp.example[0][j],
            temp.example[1][j],
            temp.example[2][j],
            directory);
      }
    }








  }



  // debugPrint("문제번호는$i");
  // debugPrint("${temp.toString()}");

  debugPrint("로딩끝남");
  return punchList;
}
