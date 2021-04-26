import 'dart:io';

import 'package:capstone/logic/dev_cube.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Exam {
  late List<dynamic> problemList;
  late int remainTime;
  late String directory;
  late String dateCode;
  late List<int> userAnswer;

  Exam(
      {required this.problemList,
      required this.remainTime,
      required this.directory,
      required this.dateCode}) {
    this.userAnswer = List.filled(this.problemList.length, -1);
  }
}

class Problem {
  // late final int seed;
  //
  /// 문제 종류 (전개도, 종이접기 등)
  late final int problemType;

  /// 지문 종류 (올바른것을 고르시오 / 틀린 것을 고르시오)
  late final int textType;

  late final int difficulty;
  late final int answer;

  // png 생성하여 디렉토리에 저장 함수
  // String 문제 예시 이미지 경로
  // List<String> 문제 보기 이미지 경로

}

/// problemType = 0
class CubeProblem extends Problem {
  // 문제 수치 데이터
  // 보기 수치 데이터
  // 오답 노트 관련 데이터
  late DevCube primitiveData;

  CubeProblem({required this.primitiveData}) {
    this.problemType = 0;
    this.textType = primitiveData.type;
    this.difficulty = primitiveData.level;
    this.answer = primitiveData.answer[0];
  }
}
