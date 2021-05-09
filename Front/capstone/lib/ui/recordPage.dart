import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../exam.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  // SegmentControl Tab Collection
  Map<int, Widget> segmentControlTabs = {
    0: SegmentTabs(
      text: "3D 전개도 유형",
    ),
    1: SegmentTabs(
      text: "종이접기 유형",
    ),
  };

  // index for SegmentControl - difficulty
  int segment = 0;

  // data
  List<int> problemsN = [0, 0];
  List<int> corretsN = [0, 0];
  List<int> totalTime = [0, 0];

  void calData(int segment) {
    var completeExamListHive = Hive.box('completeExamList');
    List<dynamic> list;

    if (completeExamListHive.isNotEmpty) {
      list = completeExamListHive.get("completeExamList");
      for (int i = 0; i < list.length; i++) {
        for (int j = 0; j < list[i].problemList.length; j++) {
          totalTime[segment] = list[i].elapsedTime + totalTime[segment];
          // 문제 종류 판단
          if (list[i].problemList[j].problemType == segment) {
            problemsN[segment]++;
          }
          // 정답 개수 판단
          if (list[i].problemList[j].answer == list[i].userAnswer[j]) {
            corretsN[segment]++;
          }
        }
      }
    } else {
      debugPrint("completeExamListHive Box에 저장된 값이 없습니다.");
      problemsN[segment] = -1;
      corretsN[segment] = -1;
      totalTime[segment] = -1;
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    calData(segment);
    print("problemsN : $problemsN, correctsN : $corretsN, times : $totalTime");
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          // Strange...
          heroTag: "recordPage",
          transitionBetweenRoutes: false,
          // Strange...
          middle: Text(
            "기록",
            style: TextStyle(fontSize: 18),
          ),
        ),
        child: SingleChildScrollView(
          // Padding for Navigation bar and Tabbar
          padding: EdgeInsets.only(top: 70, bottom: 50),
          child: Column(
            children: [
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
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        width: double.infinity,
                        child: Text("문제 통계",
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
                        value: corretsN[segment].toString(),
                      ),
                      RecordCard(
                        icon: Icon(CupertinoIcons.percent),
                        name: "정답률",
                        value: ((corretsN[segment] / problemsN[segment]) * 100)
                                .toStringAsFixed(2) +
                            "%",
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
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
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
        color: Color(0x184386F9),
        borderRadius: BorderRadius.circular(10.0),
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

class SegmentTabs extends StatelessWidget {
  String text;
  SegmentTabs({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      child: Center(child: Text(text)),
    );
  }
}
