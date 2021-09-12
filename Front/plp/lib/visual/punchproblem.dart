import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:ui' as UI;
import 'dart:ui';
import 'package:image_compare/image_compare.dart';

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
    List<File> FileList=[]; //이미지 파일을 담을 리스트
    for (int j = 0; j < 4; j++) {
      await drawpunchsuggestionpng(
          'example' + (i + counter).toString() + '_' + j.toString(),
          temp.suggestion[j],
          directory);
      FileList.add(File(directory+'/example' + (i + counter).toString() + '_' + j.toString()+'.png'));
    }

    bool is_same=false;
    for(int j=0;j<3;j++)
    {
      for(int k=j+1;k<4;k++)
      {
        var result = await compareImages(src1: FileList[j], src2: FileList[k], algorithm:EuclideanColorDistance());
        debugPrint('${i}번째 ${j}와 ${k}를 비교한 결과는 바로 ${result}');
        if(result<= 0.001) //만약 두 이미지의 차이가 일정수치보다 작다면
            {
          debugPrint('같은문제 발견 문제 재생성 on');
          is_same=true;
          break;
        }
      }
    }
    if(is_same) //문제 재 생성
        {
      i--;
      continue;
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



    punchList.add(Problem(
        answer: temp.answer[0],
        problemType: 2,
        difficulty: temp.level,
        textType: 0));


  }



  // debugPrint("문제번호는$i");
  // debugPrint("${temp.toString()}");

  debugPrint("로딩끝남");
  return punchList;
}
