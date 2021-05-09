import 'package:capstone/logic/dev_cube.dart';
import 'package:capstone/logic/paper_fold.dart';
import 'package:hive/hive.dart';

part 'exam.g.dart';

@HiveType(typeId: 0)
class Exam extends HiveObject {
  @HiveField(0)
  late List<Problem> problemList;

  /// 플레이한 이후 경과 시간
  @HiveField(1)
  late int elapsedTime = 0;

  @HiveField(2)
  late String directory;

  /// 최초 설정한 시간
  @HiveField(3)
  late int settingTime;

  @HiveField(4)
  bool complete = false;

  @HiveField(5)
  late String dateCode;

  @HiveField(6)
  late List<int> userAnswer;

  Exam(
      {required this.problemList,
      required this.directory,
      required this.dateCode,
      required this.settingTime}) {
    this.userAnswer = List.filled(this.problemList.length, -1);
  }
}

@HiveType(typeId: 1)
class Problem {
  // late final int seed;

  /// 문제 종류 (전개도, 종이접기 등)
  @HiveField(7)
  int problemType = -1;

  /// 지문 종류 (올바른것을 고르시오 / 틀린 것을 고르시오)
  @HiveField(8)
  int textType = -1;

  @HiveField(9)
  int difficulty = -1;

  @HiveField(10)
  int answer = -1;

  Problem(
      {required this.textType,
      required this.problemType,
      required this.difficulty,
      required this.answer});

  // png 생성하여 디렉토리에 저장 함수
  // String 문제 예시 이미지 경로
  // List<String> 문제 보기 이미지 경로

}
