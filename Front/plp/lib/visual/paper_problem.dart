import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_compare/image_compare.dart';
import 'dart:ui' as UI;

import '../exam.dart';
import '../main.dart';
import 'paper_png.dart';
import 'load.dart';
import '../logic/paper_fold.dart';

Future<List<Problem>> makepaperproblem(
    int num, int level, String directory, int counter) async {
  List<Problem> foldList = [];
  debugPrint("페이퍼 문제 : 로딩시작");
  for (int i = 1; i <= num; i++) {
    debugPrint("페이퍼 문제$i");
    var temp = PaperFold(level: level);
     //debugPrint(temp.example[0][0].colors[0].toString());
    // debugPrint(temp.example[0][1].layerCount.toString());
    // debugPrint(temp.example[0][1].layers.toString());

    // debugPrint(temp.example[1][1].toString());

    List<File> FileList=[]; //이미지 파일을 담을 리스트
    for (int j = 0; j < 4; j++) {
      await drawpaperpng(
          'example' + (i + counter).toString() + '_' + j.toString(),
          temp.suggestion[j],
          temp.example[1][0],
          true,
          true,
          directory);
      FileList.add(File(directory+ '/example' + (i + counter).toString() + '_' + j.toString()+'.png'));
    }
    bool is_same=false;
    for(int j=0;j<3;j++)
      {
        for(int k=j+1;k<4;k++)
          {
            var result = await compareImages(src1: FileList[j], src2: FileList[k], algorithm:PixelMatching());
            debugPrint('${i}번째 ${j}와 ${k}를 비교한 결과는 바로 ${result}');
            if(result<= 0.005) //만약 두 이미지의 차이가 일정수치보다 작다면
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
     // debugPrint(temp.example[0][j].toString());
     // debugPrint(temp.example[1][j].toString());
      if (j == 3) {
        await drawpaperpng(
            'problem' + (i + counter).toString() + '_' + j.toString(),
            temp.example[0][j],
            temp.example[1][j],
            true,
            false,
            directory);
      } else {
        await drawpaperpng(
            'problem' + (i + counter).toString() + '_' + j.toString(),
            temp.example[0][j],
            temp.example[1][j],
            false,
            false,
            directory);
      }
    }




    for (int j = 0; j < 4; j++) {
      // debugPrint(temp.suggestion[j].toString());
      // debugPrint(temp.suggestion[j].layerCount.toString());
      if (j == 3) {
        await drawpaperpngback(
            'back' + (i + counter).toString() + '_' + j.toString(),
            temp.example[0][j],
            temp.example[1][j],
            temp.example[0][j].colors,
            true,
            false,
            directory);
        await drawpaperpngfront(
            'front' + (i + counter).toString() + '_' + j.toString(),
            temp.example[0][j],
            temp.example[1][j],
            temp.example[0][j].colors,
            true,
            false,
            directory);


      } else {
        await drawpaperpngback(
            'back' + (i + counter).toString() + '_' + j.toString(),
            temp.example[0][j],
            temp.example[1][j],
            temp.example[0][j].colors,
            false,
            false,
            directory);
        await drawpaperpngfront(
            'front' + (i + counter).toString() + '_' + j.toString(),
            temp.example[0][j],
            temp.example[1][j],
            temp.example[0][j].colors,
            false,
            false,
            directory);
      }






    }


    foldList.add(Problem(
        answer: temp.answer[0],
        problemType: 1,
        difficulty: temp.level,
        textType: temp.type));
  }
  // debugPrint("문제번호는$i");
  // debugPrint("${temp.toString()}");

  debugPrint("페이퍼 문제 : 로딩끝남");
  return foldList;
}
