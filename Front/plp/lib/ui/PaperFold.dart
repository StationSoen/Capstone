import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../exam.dart';

class PaperFold extends StatefulWidget {
  late Exam exam;
  late int index;
  late double answerSize = 125;

  PaperFold({required this.exam, required this.index});

  @override
  _PaperFoldState createState() => _PaperFoldState();
}

class _PaperFoldState extends State<PaperFold> {
  List<String> problemText = [
    "다음과 같이 종이를 접었을 때, 마지막 종이의 앞면 또는 뒷면으로 알맞은 것을 고르시오.",
    "다음과 같이 종이를 접었을 때, 마지막 종이의 앞면 또는 뒷면으로 알맞지 않은 것을 고르시오.",
  ];

  Color checkWrongSelect(
      {required List<int> userAnswerList,
      required List<dynamic> problemList,
      required int index,
      required select}) {
    if (problemList[index].answer == select) {
      return const Color(0xFF4386F9);
    } else if (userAnswerList[index] == select) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  bool isVisible = true;

  Widget notes(bool isVisible) {
    if (isVisible) {
      return Expanded(
        flex: 2,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "단계별 앞면",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 75,
                      child: Image.file(
                        File(this.widget.exam.directory +
                            "/problem" +
                            (this.widget.index + 1).toString() +
                            "_0.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 75,
                      child: Image.file(
                        File(this.widget.exam.directory +
                            "/problem" +
                            (this.widget.index + 1).toString() +
                            "_1.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 75,
                      child: Image.file(
                        File(this.widget.exam.directory +
                            "/problem" +
                            (this.widget.index + 1).toString() +
                            "_2.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 75,
                      child: Image.file(
                        File(this.widget.exam.directory +
                            "/problem" +
                            (this.widget.index + 1).toString() +
                            "_3.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "단계별 뒷면",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 75,
                      child: Image.file(
                        File(this.widget.exam.directory +
                            "/back" +
                            (this.widget.index + 1).toString() +
                            "_0.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 75,
                      child: Image.file(
                        File(this.widget.exam.directory +
                            "/back" +
                            (this.widget.index + 1).toString() +
                            "_1.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 75,
                      child: Image.file(
                        File(this.widget.exam.directory +
                            "/back" +
                            (this.widget.index + 1).toString() +
                            "_2.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 75,
                      child: Image.file(
                        File(this.widget.exam.directory +
                            "/back" +
                            (this.widget.index + 1).toString() +
                            "_3.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ],
            )),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        trailing: CupertinoButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            setState(() {
              isVisible = !isVisible;
            });
          },
          child: Icon(
            CupertinoIcons.sparkles,
            size: 26,
            color: Colors.red,
          ),
        ),
        middle: Text(
            "오답노트 : ${(this.widget.index + 1).toString().padLeft(2, '0')}번 문제"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            notes(isVisible),
            // problem Card
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  child: Column(
                    children: [
                      // Problem Question Section
                      Divider(),
                      Container(
                          width: double.infinity,
                          child: Text(
                            "#${this.widget.index + 1}\n${problemText[this.widget.exam.problemList[this.widget.index].textType]}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          )),
                      Divider(),
                      Container(
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 75,
                                  child: Image.file(
                                    File(this.widget.exam.directory +
                                        "/problem" +
                                        (this.widget.index + 1).toString() +
                                        "_0.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  width: 75,
                                  child: Image.file(
                                    File(this.widget.exam.directory +
                                        "/problem" +
                                        (this.widget.index + 1).toString() +
                                        "_1.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  width: 75,
                                  child: Image.file(
                                    File(this.widget.exam.directory +
                                        "/problem" +
                                        (this.widget.index + 1).toString() +
                                        "_2.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  width: 75,
                                  child: Image.file(
                                    File(this.widget.exam.directory +
                                        "/problem" +
                                        (this.widget.index + 1).toString() +
                                        "_3.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 45,
                              child: Image(
                                image: AssetImage('assets/fold/paperex.png'),
                                fit: BoxFit.cover,
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(),

                      // Problem Answers Section
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CupertinoButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: checkWrongSelect(
                                          problemList:
                                              this.widget.exam.problemList,
                                          userAnswerList:
                                              this.widget.exam.userAnswer,
                                          index: this.widget.index,
                                          select: 0),
                                    ),
                                  ),
                                  height: this.widget.answerSize,
                                  width: this.widget.answerSize,
                                  child: Image.file(
                                    File(this.widget.exam.directory +
                                        "/example" +
                                        (this.widget.index + 1).toString() +
                                        "_" +
                                        "0" +
                                        ".png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: checkWrongSelect(
                                          problemList:
                                              this.widget.exam.problemList,
                                          userAnswerList:
                                              this.widget.exam.userAnswer,
                                          index: this.widget.index,
                                          select: 1),
                                    ),
                                  ),
                                  height: this.widget.answerSize,
                                  width: this.widget.answerSize,
                                  child: Image.file(
                                    File(this.widget.exam.directory +
                                        "/example" +
                                        (this.widget.index + 1).toString() +
                                        "_" +
                                        "1" +
                                        ".png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CupertinoButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: checkWrongSelect(
                                            problemList:
                                                this.widget.exam.problemList,
                                            userAnswerList:
                                                this.widget.exam.userAnswer,
                                            index: this.widget.index,
                                            select: 2),
                                      ),
                                    ),
                                    height: this.widget.answerSize,
                                    width: this.widget.answerSize,
                                    child: Image.file(
                                      File(this.widget.exam.directory +
                                          "/example" +
                                          (this.widget.index + 1).toString() +
                                          "_" +
                                          "2" +
                                          ".png"),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                CupertinoButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: checkWrongSelect(
                                            problemList:
                                                this.widget.exam.problemList,
                                            userAnswerList:
                                                this.widget.exam.userAnswer,
                                            index: this.widget.index,
                                            select: 3),
                                      ),
                                    ),
                                    height: this.widget.answerSize,
                                    width: this.widget.answerSize,
                                    child: Image.file(
                                      File(this.widget.exam.directory +
                                          "/example" +
                                          (this.widget.index + 1).toString() +
                                          "_" +
                                          "3" +
                                          ".png"),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                )
                              ])
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
