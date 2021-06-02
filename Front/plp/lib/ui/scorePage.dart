import 'package:hive/hive.dart';
import 'package:plp/ui/PunchHole.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:plp/ui/block3D.dart';

import '../exam.dart';
import 'PaperFold.dart';
import 'component.dart';
import 'cube3D.dart';

class ScorePage extends StatefulWidget {
  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  late Exam exam;
  int remainProblems = 0;
  DateFormat formatter = DateFormat("MM/dd HH:mm:ss");

  // level test variable
  bool isLevelTest = false;
  bool isLevelTestPass = false;

  @override
  Widget build(BuildContext context) {
    exam = ModalRoute.of(context)!.settings.arguments as Exam;
    for (int i = 0; i < exam.problemList.length; i++) {
      if (exam.userAnswer[i] == -1) {
        remainProblems++;
      }
    }

    List<bool> correctList = [];
    int correct = 0;
    List<int> typeList = [];
    List<int> difficultyList = [];

    List<String> typeString = ['전개도', '종이접기', '펀칭', '블럭쌓기'];
    List<String> difficultyString = ['쉬움', '보통', '어려움'];
    List<String> examTypeList = ['일반 문제지', '무작위 생성 문제', '레벨 테스트'];

    for (int i = 0; i < exam.problemList.length; i++) {
      typeList.add(exam.problemList[i].problemType);
      difficultyList.add(exam.problemList[i].difficulty);
      if (exam.userAnswer[i] == exam.problemList[i].answer) {
        correctList.add(true);
        correct++;
      } else {
        correctList.add(false);
      }
    }

    // if levelTest EXAM,
    if (exam.examType == 2) {
      isLevelTest = true;
      if (!correctList.contains(false)) {
        isLevelTestPass = true;
        var hiveLevelTest = Hive.box('levelTest');
        List<int> levelList = hiveLevelTest.get('level');
        if (levelList[exam.problemList[0].problemType] <=
            exam.problemList[0].difficulty + 1) {
          levelList[exam.problemList[0].problemType] =
              exam.problemList[0].difficulty + 1;
          hiveLevelTest.put("level", levelList);
        }
      }
    }

    String type = "";

    if (typeList.contains(0)) {
      type = type +
          typeString[typeList.firstWhere((element) => element == 0)] +
          ", ";
      // type = type +
      //     difficultyString[
      //         difficultyList[typeList.indexWhere((element) => element == 0)]] +
      //     " ";
    }
    if (typeList.contains(1)) {
      type = type +
          typeString[typeList.firstWhere((element) => element == 1)] +
          ", ";
      // type = type +
      //     difficultyString[
      //         difficultyList[typeList.indexWhere((element) => element == 1)]] +
      //     " ";
    }
    if (typeList.contains(2)) {
      type = type +
          typeString[typeList.firstWhere((element) => element == 2)] +
          ", ";
      // "-";
      // type = type +
      //     difficultyString[
      //         difficultyList[typeList.indexWhere((element) => element == 2)]] +
      //     " ";
    }

    if (typeList.contains(3)) {
      type = type + typeString[typeList.firstWhere((element) => element == 3)];
      // "-";
      // type = type +
      //     difficultyString[
      //         difficultyList[typeList.indexWhere((element) => element == 3)]] +
      //     " ";
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: CupertinoNavigationBar(
            // Strange...
            heroTag: "recordPage",
            transitionBetweenRoutes: false,
            // Strange...
            middle: Text(
              "문제 정보",
              style: TextStyle(fontSize: 18),
            ),
            leading: Container(),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      levelTest(isPass: isLevelTestPass, isTest: isLevelTest),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 20),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: basicBox,
                          width: 345,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "시험 결과",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                Divider(),
                                Text(
                                  "${correct.toString().padLeft(2, '0')} / ${exam.problemList.length.toString().padLeft(2, '0')}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 48),
                                )
                              ])),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 20),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: basicBox,
                          width: 345,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "문제 정보",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                Divider(),
                                infoRow(
                                    "문제 생성일",
                                    formatter.format(
                                        DateFormat('MM_dd_HH_mm_ss')
                                            .parse(exam.dateCode))),
                                infoRow("문제지 유형", examTypeList[exam.examType]),
                                infoRow("전체 풀이 시간",
                                    "${(exam.settingTime / 60).toInt().toString().padLeft(2, "0")}:${(exam.settingTime % 60).toInt().toString().padLeft(2, "0")}"),
                                infoRow("전체 문제 수",
                                    exam.problemList.length.toString()),
                                infoRow("문제 유형", type),
                                Divider(),
                                infoRow("소요 시간",
                                    "${(exam.elapsedTime / 60).toInt().toString().padLeft(2, "0")}:${(exam.elapsedTime % 60).toInt().toString().padLeft(2, "0")}"),
                              ])),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 20),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: basicBox,
                          width: 345,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "정오표",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                Divider(),
                                problemList(
                                    correctList.length, correctList, typeList),
                              ])),
                      CircleButton(
                        text: "돌아가기",
                        color: const Color(0xFF4386F9),
                        textColor: Colors.white,
                        width: 345,
                        marginVertical: 10,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ]),
              ),
            ),
          )),
    );
  }

  Widget levelTest({required isTest, required isPass}) {
    if (isTest) {
      if (isPass) {
        // level test pass
        return Container(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: basicBox,
          width: 345,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "레벨 테스트 합격",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue),
              ),
            ),
          ),
        );
      } else {
        // level test non-pass
        return Container(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: basicBox,
          width: 345,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "레벨 테스트 불합격",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.red),
              ),
            ),
          ),
        );
      }
    } else {
      return Container();
    }
  }

  Widget infoRow(String title, String info) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        Text(
          info,
          style: TextStyle(fontSize: 17, color: Colors.grey),
        )
      ]),
    );
  }

  Widget problemList(int number, List<bool> correctList, List<int> typeList) {
    List<Widget> result = [];
    List<String> type = ["전개도 유형", "종이접기 유형", "펀칭 유형", "블럭쌓기 유형"];

    for (int i = 0; i < number; i++) {
      if (correctList[i]) {
        result.add(CupertinoButton(
            padding: EdgeInsets.all(0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "#${(i + 1).toString().padLeft(2, '0')} - " +
                        type[typeList[i]],
                    style:
                        TextStyle(fontSize: 17, color: const Color(0xFF4386F9)),
                  ),
                  Text(
                    "정답",
                    style:
                        TextStyle(fontSize: 17, color: const Color(0xFF4386F9)),
                  )
                ]),
            onPressed: () {
              if (typeList[i] == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Cube3D(
                      exam: exam,
                      index: i,
                    ),
                  ),
                );
              } else if (typeList[i] == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => PaperFold(
                      exam: exam,
                      index: i,
                    ),
                  ),
                );
              } else if (typeList[i] == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => PunchHole(
                      exam: exam,
                      index: i,
                    ),
                  ),
                );
              }
            }));
      } else {
        result.add(CupertinoButton(
            padding: EdgeInsets.all(0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "#${(i + 1).toString().padLeft(2, '0')} - " +
                        type[typeList[i]],
                    style: TextStyle(fontSize: 17, color: Colors.red),
                  ),
                  Text(
                    "오답",
                    style: TextStyle(fontSize: 17, color: Colors.red),
                  )
                ]),
            onPressed: () {
              if (typeList[i] == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Cube3D(
                      exam: exam,
                      index: i,
                    ),
                  ),
                );
              } else if (typeList[i] == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => PaperFold(
                      exam: exam,
                      index: i,
                    ),
                  ),
                );
              } else if (typeList[i] == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => PunchHole(
                      exam: exam,
                      index: i,
                    ),
                  ),
                );
              } else if (typeList[i] == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Block3D(
                      exam: exam,
                      index: i,
                    ),
                  ),
                );
              }
            }));
      }
    }

    return Container(
      child: Column(
        children: result,
      ),
    );
  }
}
