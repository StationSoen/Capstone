import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:plp/main.dart';
import 'package:plp/ui/component.dart';

import '../exam.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  // SegmentControl Tab Collection
  Map<int, Widget> segmentControlTabs = {
    0: SegmentTabs(
      text: "전개도 유형",
    ),
    1: SegmentTabs(
      text: "종이접기 유형",
    ),
    2: SegmentTabs(
      text: "펀칭 유형",
    ),
    3: SegmentTabs(
      text: "블록쌓기 유형",
    ),
  };

  // index for SegmentControl - difficulty
  int segment = 0;

  // data
  List<int> problemsN = [0, 0, 0, 0];
  List<int> correctsN = [0, 0, 0, 0];
  List<int> totalTime = [0, 0, 0, 0];
  List<double> correctPercent = [0.0, 0.0, 0.0, 0.0];

  void calData(int segment) {
    var completeExamListHive = Hive.box('completeExamList');
    List<dynamic> list;

    int problemNumber = 0;
    int correctNumber = 0;
    int times = 0;

    if (completeExamListHive.isNotEmpty) {
      list = completeExamListHive.get("completeExamList");
      for (int i = 0; i < list.length; i++) {
        times = list[i].elapsedTime + times;
        for (int j = 0; j < list[i].problemList.length; j++) {
          // 문제 종류 판단
          if (list[i].problemList[j].problemType == segment) {
            problemNumber++;
            if (list[i].problemList[j].answer == list[i].userAnswer[j]) {
              correctNumber++;
            }
          }
        }
      }
    } else {
      debugPrint("completeExamListHive Box에 저장된 값이 없습니다.");
      problemsN[segment] = -1;
      correctsN[segment] = -1;
      totalTime[segment] = -1;
      return;
    }

    if (problemNumber == 0) {
      correctPercent[segment] = 0;
    }
    problemsN[segment] = problemNumber;
    correctsN[segment] = correctNumber;
    correctPercent[segment] = correctNumber / problemNumber;
    totalTime[segment] = times;

    if (problemNumber == 0) {
      correctPercent[segment] = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    calData(segment);
    return Container(
      // decoration: gradientBackground,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: CupertinoNavigationBar(
            backgroundColor: Colors.white,
            // Strange...
            heroTag: "recordPage",
            transitionBetweenRoutes: false,
            // Strange...
            middle: Text(
              "기록",
              style: TextStyle(fontSize: 18),
            ),
          ),
          body: SafeArea(
            child: Container(
              child: SingleChildScrollView(
                // Padding for Navigation bar and Tabbar
                child: Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      width: double.infinity,
                      child: Text("유형별 달성한 레벨",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              color: Colors.black)),
                    ),
                    LevelCard(
                      name: "전개도 유형",
                      level: 0,
                    ),
                    LevelCard(
                      name: "종이접기 유형",
                      level: 1,
                    ),
                    LevelCard(
                      name: "펀칭 유형",
                      level: 2,
                    ),
                    LevelCard(
                      name: "블록쌓기 유형",
                      level: 2,
                    ),
                    Divider(),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      width: double.infinity,
                      child: Text("전체 통계",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              color: Colors.black)),
                    ),
                    RecordCard(
                        icon: Icon(CupertinoIcons.alarm),
                        name: "풀이한 시간",
                        value: (totalTime[segment] ~/ 3600)
                                .toString()
                                .padLeft(2, '0') +
                            " : " +
                            (totalTime[segment] ~/ 60)
                                .toString()
                                .padLeft(2, '0') +
                            " : " +
                            (totalTime[segment] % 60)
                                .toString()
                                .padLeft(2, '0')),
                    Divider(),
                    CupertinoSegmentedControl(
                      children: segmentControlTabs,
                      groupValue: segment,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      onValueChanged: (int value) {
                        setState(() {
                          segment = value;
                        });
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      width: double.infinity,
                      child: Text("유형별 통계",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              color: Colors.black)),
                    ),
                    RecordCard(
                      icon: Icon(CupertinoIcons.square),
                      name: "시도한 문제",
                      value: problemsN[segment].toString(),
                    ),
                    RecordCard(
                      icon: Icon(CupertinoIcons.circle),
                      name: "성공한 문제",
                      value: correctsN[segment].toString(),
                    ),
                    RecordCard(
                      icon: Icon(CupertinoIcons.percent),
                      name: "정답률",
                      value:
                          (correctPercent[segment] * 100).toStringAsFixed(2) +
                              "%",
                    ),
                    RecordCard(
                      icon: Icon(CupertinoIcons.percent),
                      name: "테스트 값",
                      value:
                          (correctPercent[segment] * 100).toStringAsFixed(2) +
                              "%",
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class RecordCard extends StatelessWidget {
  final Icon icon;
  final String name;
  final String value;

  RecordCard({required this.icon, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      padding: EdgeInsets.all(12),
      height: 95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.17),
            offset: Offset(0.0, 3.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            icon,
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.black))
          ]),
          Container(
              width: double.infinity,
              child: Text(name,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black)))
        ],
      ),
    );
  }
}

class LevelCard extends StatelessWidget {
  final String name;
  final int level;
  List<Color> levelList = [Colors.grey, Colors.grey, Colors.grey];

  LevelCard({required this.name, required this.level}) {
    for (int i = 0; i < level; i++) {
      levelList[i] = Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      padding: EdgeInsets.all(12),
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.17),
            offset: Offset(0.0, 3.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(name,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black)),
          ),
          Row(
            children: [
              CupertinoButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  print("tap");
                },
                child: Icon(
                  CupertinoIcons.checkmark_alt_circle,
                  size: 36,
                  color: levelList[0],
                ),
              ),
              Icon(
                CupertinoIcons.minus,
                color: Colors.grey,
              ),
              CupertinoButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  print("tap");
                },
                child: Icon(
                  CupertinoIcons.checkmark_alt_circle,
                  size: 36,
                  color: levelList[1],
                ),
              ),
              Icon(
                CupertinoIcons.minus,
                color: Colors.grey,
              ),
              CupertinoButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  showCupertinoDialog(
                      context: context, problemType: name, difficulty: 2);
                },
                child: Icon(
                  CupertinoIcons.checkmark_alt_circle,
                  size: 36,
                  color: levelList[2],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  showCupertinoDialog(
      {required BuildContext context,
      required String problemType,
      required int difficulty}) {
    showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              title: new Text("레벨 테스트"),
              content:
                  new Text("$problemType, 난이도 $difficulty 테스트를\n진행하시겠습니까?"),
              actions: [
                CupertinoButton(
                  child: Text("확인"),
                  onPressed: () {
                    print("OK");
                  },
                ),
                CupertinoButton(
                  child: Text("취소"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }
}

class SegmentTabs extends StatelessWidget {
  String text;
  SegmentTabs({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      child: Center(child: Text(text)),
    );
  }
}
