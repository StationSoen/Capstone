import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../exam.dart';
import '../main.dart';
import 'component.dart';
import 'cube3D.dart';

class ProblemDetailPage extends StatefulWidget {
  @override
  _ProblemDetailPageState createState() => _ProblemDetailPageState();
}

class _ProblemDetailPageState extends State<ProblemDetailPage> {
  late Exam exam;
  int remainProblems = 0;

  DateFormat formatter = DateFormat("MM/dd HH:mm:ss");

  @override
  Widget build(BuildContext context) {
    exam = ModalRoute.of(context)!.settings.arguments as Exam;
    for (int i = 0; i < exam.problemList.length; i++) {
      if (exam.userAnswer[i] == -1) {
        remainProblems++;
      }
    }

    return WillPopScope(
        onWillPop: () async => false,
        child: CupertinoPageScaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          navigationBar: CupertinoNavigationBar(
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
          child: SingleChildScrollView(
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 70, bottom: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: basicBox,
                        width: 345,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "문제 정보",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                              Divider(),
                              infoRow(
                                  "문제 생성일",
                                  formatter.format(DateFormat('MM_dd_HH_mm_ss')
                                      .parse(exam.dateCode))),
                              infoRow("전체 풀이 시간",
                                  "${(exam.settingTime / 60).toInt().toString().padLeft(2, "0")}:${(exam.settingTime % 60).toInt().toString().padLeft(2, "0")}"),
                              infoRow("전체 문제 수",
                                  exam.problemList.length.toString()),
                              infoRow("문제 유형", "전개도, 종이접기"),
                              Divider(),
                              infoRow("남은 풀이 시간",
                                  "${((exam.settingTime - exam.elapsedTime) / 60).toInt().toString().padLeft(2, "0")}:${((exam.settingTime - exam.elapsedTime) % 60).toInt().toString().padLeft(2, "0")}"),
                              infoRow("남은 문제 수", remainProblems.toString()),
                            ])),
                    Column(
                      children: [
                        CircleButton(
                          text: "계속 진행하기",
                          color: const Color(0xFF4386F9),
                          textColor: Colors.white,
                          width: 345,
                          marginVertical: 5,
                          onPressed: () {
                            Navigator.pushNamed(context, '/problemPage',
                                arguments: exam);
                          },
                        ),
                        CircleButton(
                          text: "취소",
                          color: Colors.red,
                          textColor: Colors.white,
                          width: 345,
                          marginVertical: 5,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ],
                )),
          ),
        ));
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
}
