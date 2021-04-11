import 'dart:core';

import 'package:capstone/mtlTestPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'component.dart';
import 'exam.dart';

class ScorePage extends StatefulWidget {
  late Exam exam;

  ScorePage({required this.exam});

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  int correct = 0;
  List<bool> correctList = [];

  @override
  void initState() {
    for (int i = 0; i < this.widget.exam.numberOfProblems; i++) {
      if (this.widget.exam.userAnswers[i] == this.widget.exam.answerList[i]) {
        correctList.add(true);
        correct++;
      } else {
        correctList.add(false);
      }
    }

    debugPrint("asd : " + correctList.length.toString());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              "결과",
              style: TextStyle(fontSize: 18),
            ),
            leading: Container(),
          ),
          child: Container(
              width: double.infinity,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                "시험 결과",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                              Divider(),
                              Text(
                                "${correct.toString().padLeft(2, '0')} / ${this.widget.exam.numberOfProblems.toString().padLeft(2, '0')}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 48),
                              )
                            ])),
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
                                "정오표",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                              Divider(),
                              problemList(correctList.length, correctList),
                            ])),
                    CircleButton(
                      text: "확인",
                      color: Colors.blue,
                      textColor: Colors.white,
                      width: 345,
                      marginVertical: 5,
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                    )
                  ],
                ),
              ))),
    );
  }

  Widget problemList(int number, List<bool> correctList) {
    List<Widget> result = [];

    for (int i = 0; i < number; i++) {
      if (correctList[i]) {
        result.add(CupertinoButton(
            padding: EdgeInsets.all(0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "#${(i + 1).toString().padLeft(2, '0')} - 전개도 유형",
                    style: TextStyle(fontSize: 17, color: Colors.blue),
                  ),
                  Text(
                    "정답",
                    style: TextStyle(fontSize: 17, color: Colors.blue),
                  )
                ]),
            onPressed: () {
              debugPrint("Button Tapped!");
            }));
      } else {
        result.add(CupertinoButton(
            padding: EdgeInsets.all(0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "#${(i + 1).toString().padLeft(2, '0')} - 전개도 유형",
                    style: TextStyle(fontSize: 17, color: Colors.red),
                  ),
                  Text(
                    "오답",
                    style: TextStyle(fontSize: 17, color: Colors.red),
                  )
                ]),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MtlTestPage(
                    exam: this.widget.exam,
                    index: i,
                  ),
                ),
              );
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
