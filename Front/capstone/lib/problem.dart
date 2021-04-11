import 'package:flutter/material.dart';
import 'dart:ui' as UI;
import 'dart:ui';

import 'main.dart';
import 'png.dart';
import 'load.dart';
import 'dev_cube.dart';

Future<List<DevCube>> makecubeproblem(
  int num,
  int level,
  String directory,
) async {
  List<DevCube> cubeList = [];
  for (int i = 1; i <= num; i++) {
    var temp = DevCube(level);
    cubeList.add(temp);
    debugPrint("문제번호는$i");
    debugPrint("${temp.toString()}");
    // debugPrint("${  int.parse(temp.example[0][1][0])}");
    // debugPrint("${  int.parse(temp.example[0][1][1])}");
    // debugPrint("${  temp.example[0]}");
    //  debugPrint("${  temp.example[1][5] }");
    //debugPrint("${  temp.example[2][5] }");
    // debugPrint("${  temp.example[0][0][2] }");
    if (temp.level > 0) {
      switch (temp.type) {
        case 0:
        case 1:
          await drawtemplatepng(
              'problem' + i.toString(),
              temp.example[2][0],
              int.parse(temp.example[0][0][1]),
              int.parse(temp.example[0][0][0]),
              int.parse(temp.example[1][0]) * -90,
              temp.example[2][1],
              int.parse(temp.example[0][1][1]),
              int.parse(temp.example[0][1][0]),
              int.parse(temp.example[1][1]) * -90,
              temp.example[2][2],
              int.parse(temp.example[0][2][1]),
              int.parse(temp.example[0][2][0]),
              int.parse(temp.example[1][2]) * -90,
              temp.example[2][3],
              int.parse(temp.example[0][3][1]),
              int.parse(temp.example[0][3][0]),
              int.parse(temp.example[1][3]) * -90,
              temp.example[2][4],
              int.parse(temp.example[0][4][1]),
              int.parse(temp.example[0][4][0]),
              int.parse(temp.example[1][4]) * -90,
              temp.example[2][5],
              int.parse(temp.example[0][5][1]),
              int.parse(temp.example[0][5][0]),
              int.parse(temp.example[1][5]) * -90,
              directory);

          for (int j = 0; j <= 3; j++) {
            await drawisopng(
                'example' + i.toString() + '_' + j.toString(),
                temp.suggestion[j][0][0],
                (temp.suggestion[j][1][0] * -90),
                temp.suggestion[j][0][1],
                (temp.suggestion[j][1][1] + 1) * -90,
                temp.suggestion[j][0][2],
                (temp.suggestion[j][1][2] + 2) * -90,
                directory);
          }
          await drawmtlpng(
              'mtl' + i.toString(),
              temp.answer[1][2][1],
              90,
              temp.answer[1][2][2],
              270,
              temp.answer[1][2][3],
              180,
              temp.answer[1][2][0],
              180,
              temp.answer[1][2][4],
              0,
              temp.answer[1][2][5],
              270,
              directory);

          break;

        case 2:
        case 3:
        case 4:
          if (temp.type != 4) {
            await drawisopng(
                'problem' + i.toString(),
                temp.example[0][0],
                (temp.example[1][0] * -90),
                temp.example[0][1],
                (temp.example[1][1] + 1) * -90,
                temp.example[0][2],
                (temp.example[1][2] + 2) * -90,
                directory);
          }

          for (int j = 0; j <= 3; j++) {
            await drawtemplatepng(
                'example' + i.toString() + '_' + j.toString(),
                temp.suggestion[j][2][0],
                int.parse(temp.suggestion[j][0][0][1]),
                int.parse(temp.suggestion[j][0][0][0]),
                int.parse(temp.suggestion[j][1][0]) * -90,
                temp.suggestion[j][2][1],
                int.parse(temp.suggestion[j][0][1][1]),
                int.parse(temp.suggestion[j][0][1][0]),
                int.parse(temp.suggestion[j][1][1]) * -90,
                temp.suggestion[j][2][2],
                int.parse(temp.suggestion[j][0][2][1]),
                int.parse(temp.suggestion[j][0][2][0]),
                int.parse(temp.suggestion[j][1][2]) * -90,
                temp.suggestion[j][2][3],
                int.parse(temp.suggestion[j][0][3][1]),
                int.parse(temp.suggestion[j][0][3][0]),
                int.parse(temp.suggestion[j][1][3]) * -90,
                temp.suggestion[j][2][4],
                int.parse(temp.suggestion[j][0][4][1]),
                int.parse(temp.suggestion[j][0][4][0]),
                int.parse(temp.suggestion[j][1][4]) * -90,
                temp.suggestion[j][2][5],
                int.parse(temp.suggestion[j][0][5][1]),
                int.parse(temp.suggestion[j][0][5][0]),
                int.parse(temp.suggestion[j][1][5]) * -90,
                directory);
          }

          await drawmtlpng(
              'mtl' + i.toString(),
              temp.answer[1][2][1],
              90,
              temp.answer[1][2][2],
              270,
              temp.answer[1][2][3],
              180,
              temp.answer[1][2][0],
              180,
              temp.answer[1][2][4],
              0,
              temp.answer[1][2][5],
              270,
              directory);

          break;
      }
    } else {
      switch (temp.type) {
        case 0:
        case 1:
          await drawcolortemplatepng(
              'problem' + i.toString(),
              colorlist[temp.example[2][0]],
              int.parse(temp.example[0][0][1]),
              int.parse(temp.example[0][0][0]),
              colorlist[temp.example[2][1]],
              int.parse(temp.example[0][1][1]),
              int.parse(temp.example[0][1][0]),
              colorlist[temp.example[2][2]],
              int.parse(temp.example[0][2][1]),
              int.parse(temp.example[0][2][0]),
              colorlist[temp.example[2][3]],
              int.parse(temp.example[0][3][1]),
              int.parse(temp.example[0][3][0]),
              colorlist[temp.example[2][4]],
              int.parse(temp.example[0][4][1]),
              int.parse(temp.example[0][4][0]),
              colorlist[temp.example[2][5]],
              int.parse(temp.example[0][5][1]),
              int.parse(temp.example[0][5][0]),
              directory);

          for (int j = 0; j <= 3; j++) {
            await drawcolorisopng(
                'example' + i.toString() + '_' + j.toString(),
                colorlist[temp.suggestion[j][0][0]],
                colorlist[temp.suggestion[j][0][1]],
                colorlist[temp.suggestion[j][0][2]],
                directory);
          }
          await drawcolormtlpng(
              'mtl' + i.toString(),
              colorlist[temp.answer[1][2][1]],
              colorlist[temp.answer[1][2][2]],
              colorlist[temp.answer[1][2][3]],
              colorlist[temp.answer[1][2][0]],
              colorlist[temp.answer[1][2][4]],
              colorlist[temp.answer[1][2][5]],
              directory);
          break;

        case 2:
        case 3:
        case 4:
          if (temp.type != 4) {
            await drawcolorisopng(
                'problem' + i.toString(),
                colorlist[temp.example[0][0]],
                colorlist[temp.example[0][1]],
                colorlist[temp.example[0][2]],
                directory);
          }

          for (int j = 0; j <= 3; j++) {
            await drawcolortemplatepng(
                'example' + i.toString() + '_' + j.toString(),
                colorlist[temp.suggestion[j][2][0]],
                int.parse(temp.suggestion[j][0][0][1]),
                int.parse(temp.suggestion[j][0][0][0]),
                colorlist[temp.suggestion[j][2][1]],
                int.parse(temp.suggestion[j][0][1][1]),
                int.parse(temp.suggestion[j][0][1][0]),
                colorlist[temp.suggestion[j][2][2]],
                int.parse(temp.suggestion[j][0][2][1]),
                int.parse(temp.suggestion[j][0][2][0]),
                colorlist[temp.suggestion[j][2][3]],
                int.parse(temp.suggestion[j][0][3][1]),
                int.parse(temp.suggestion[j][0][3][0]),
                colorlist[temp.suggestion[j][2][4]],
                int.parse(temp.suggestion[j][0][4][1]),
                int.parse(temp.suggestion[j][0][4][0]),
                colorlist[temp.suggestion[j][2][5]],
                int.parse(temp.suggestion[j][0][5][1]),
                int.parse(temp.suggestion[j][0][5][0]),
                directory);
          }

          await drawcolormtlpng(
              'mtl' + i.toString(),
              colorlist[temp.answer[1][2][1]],
              colorlist[temp.answer[1][2][2]],
              colorlist[temp.answer[1][2][3]],
              colorlist[temp.answer[1][2][0]],
              colorlist[temp.answer[1][2][4]],
              colorlist[temp.answer[1][2][5]],
              directory);

          break;
      }
    }
  }

  debugPrint("로딩끝남");
  return cubeList;
}
