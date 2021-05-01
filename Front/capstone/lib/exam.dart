import 'dart:io';

import 'package:capstone/logic/dev_cube.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

part 'exam.g.dart';

@HiveType(typeId: 0)
class Exam extends HiveObject {
  @HiveField(0)
  late List<dynamic> problemList;

  @HiveField(1)
  late int remainTime;

  @HiveField(2)
  late String directory;

  @HiveField(3)
  late String dateCode;

  @HiveField(4)
  late List<int> userAnswer;

  Exam(
      {required this.problemList,
      required this.remainTime,
      required this.directory,
      required this.dateCode}) {
    this.userAnswer = List.filled(this.problemList.length, -1);
  }
}

@HiveType(typeId: 1)
class Problem {
  // late final int seed;
  //
  /// 문제 종류 (전개도, 종이접기 등)
  @HiveField(5)
  late final int problemType;

  /// 지문 종류 (올바른것을 고르시오 / 틀린 것을 고르시오)
  @HiveField(6)
  late final int textType;

  @HiveField(7)
  late final int difficulty;

  @HiveField(8)
  late final int answer;

  // png 생성하여 디렉토리에 저장 함수
  // String 문제 예시 이미지 경로
  // List<String> 문제 보기 이미지 경로

}

/// problemType = 0
@HiveType(typeId: 2)
class CubeProblem extends Problem {
  // 문제 수치 데이터
  // 보기 수치 데이터
  // 오답 노트 관련 데이터
  @HiveField(9)
  late DevCube primitiveData;

  CubeProblem({required this.primitiveData}) {
    this.problemType = 0;
    this.textType = primitiveData.type;
    this.difficulty = primitiveData.level;
    this.answer = primitiveData.answer[0];
  }
}
