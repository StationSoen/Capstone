import 'package:flutter/material.dart';
import 'dart:ui' as UI;
import 'dart:ui';

import '../exam.dart';
import '../main.dart';
import 'paper_png.dart';
import 'load.dart';
import '../logic/paper_fold.dart';


Future<void> makepaperproblem(
    int num,
    int level,
    String directory,
    ) async {
  for (int i = 1; i <= num; i++) {
    var temp = PaperFold(level);
    //debugPrint(temp.example[0][1].toString());
    //debugPrint(temp.example[0][1].layerCount.toString());
    //debugPrint(temp.example[0][1].layers.toString());

    //debugPrint(temp.example[1][1].toString());
    for(int j=0;j<4;j++){
      //debugPrint(temp.example[0][j].toString());
      //debugPrint(temp.example[1][j].toString());
      if(j==3){
        drawpaperpng('problem'+i.toString()+'_'+j.toString(), temp.example[0][j], temp.example[1][j], true,false,directory);
      }
      else{
        drawpaperpng('problem'+i.toString()+'_'+j.toString(), temp.example[0][j], temp.example[1][j], false,false, directory);
      }
    }
    for(int j=0;j<4;j++){
      debugPrint(temp.suggestion[j].toString());
      debugPrint(temp.suggestion[j].layerCount.toString());
      drawpaperpng('example'+i.toString()+'_'+j.toString(), temp.suggestion[j], temp.example[1][0], true,true,directory);

    }
  }
  // debugPrint("문제번호는$i");
  // debugPrint("${temp.toString()}");


  debugPrint("로딩끝남");
  return ;
}
