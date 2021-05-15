import 'package:flutter/material.dart';
import 'dart:ui' as UI;
import 'dart:ui';

import '../exam.dart';
import '../main.dart';
import 'punch_png.dart';
import 'load.dart';
import '../logic/hole_punch.dart';

Future<void> makepunchproblem(
    int num,
    int level,
    String directory,
    ) async {
  for (int i = 1; i <= num; i++) {
    var temp =HolePunch(level: level);

    debugPrint('${i}번 문제${temp.toString()}');
    //debugPrint(temp.example[0][1].toString());
    //debugPrint(temp.example[0][1].layerCount.toString());
    //debugPrint(temp.example[0][1].layers.toString());

    //debugPrint(temp.example[1][1].toString());
    for(int j=0;j<4;j++){
      //debugPrint(temp.example[0][j].toString());
      //debugPrint(temp.example[1][j].toString());
      if(j==3){ //점을 그려야됨
        drawpunchpng('problem'+i.toString()+'_'+j.toString(), temp.example[0][j], temp.example[2], true,directory);
      }
      else{ //선을 그려야됨
        drawpunchpng('problem'+i.toString()+'_'+j.toString(), temp.example[0][j],temp.example[1][j], false, directory);
      }
    }
    for(int j=0;j<4;j++){
      drawpunchsuggestionpng('example'+i.toString()+'_'+j.toString(), temp.suggestion[j],directory);

    }
  }
  // debugPrint("문제번호는$i");
  // debugPrint("${temp.toString()}");


  debugPrint("로딩끝남");
  return ;
}
