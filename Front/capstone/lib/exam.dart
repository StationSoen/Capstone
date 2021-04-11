import 'package:capstone/dev_cube.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Exam {
  /// 고유 코드 _ 생성한 날짜 기준
  String date;

  /// 폴더 위치
  String directory;

  /// 문제 수
  int numberOfProblems;

  /// 사용자가 선택한 답 - 9의 경우 선택 안 한 것임.
  late List<int> userAnswers;

  /// 문제의 답
  List<int> problemAnswers;

  /// 남은 시간
  int remainSeconds;

  /// 문제의 유형
  int type;

  /// 난이도 선택
  int difficulty;

  List<DevCube> cubeList;

  /// 생성자, userAnswers 같은 경우 9로 만들어진 배열을 자동으로 생성.
  Exam(
      {required this.date,
      required this.directory,
      required this.numberOfProblems,
      required this.remainSeconds,
      required this.problemAnswers,
      required this.type,
      required this.difficulty,
      required this.cubeList}) {
    List<int> userAnswers = List.filled(this.numberOfProblems, 9);
  }
}
