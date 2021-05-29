import 'package:flutter/material.dart';
import 'package:flutter_app_flutter_cube_tuto/blockpng.dart';
import 'package:flutter_app_flutter_cube_tuto/punchpng.dart';
import 'package:flutter_app_flutter_cube_tuto/stack_blocks.dart';
import 'dart:ui' as UI;
import 'stack_blocks.dart';

Future<void> makeblockproblem(
    int num,
    int level,
    String directory,
    int counter,
    ) async {
  for (int i = 1; i <= num; i++) {
    var temp =StackBlocks(level: level);

    for(int j=0;j<temp.example.length;j++)
      {
        drawblockpng('problem'+(i+counter).toString()+'_'+j.toString(), temp.example[j], directory);
      }

    for(int j=0;j<temp.suggestion.length;j++)
    {
      drawblockpng('example'+(i+counter).toString()+'_'+j.toString(), temp.suggestion[j], directory);
    }

    //debugPrint(temp.example[1].toString());
    //debugPrint(temp.example[1].body[0][0][0].toString());
  }
  // debugPrint("문제번호는$i");
  // debugPrint("${temp.toString()}");


  debugPrint("로딩끝남");
  return ;
}
