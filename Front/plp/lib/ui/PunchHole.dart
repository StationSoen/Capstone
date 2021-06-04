import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../exam.dart';
import 'dart:io';

class PunchHole extends StatefulWidget {
  late Exam exam;
  late int index;
  late double answerSize = 125;

  PunchHole({required this.exam, required this.index});

  @override
  _PunchHoleState createState() => _PunchHoleState();
}

class _PunchHoleState extends State<PunchHole> {
  List<String> problemText = [
    "다음과 같이 종이를 접은 후, 구멍을 뚫고 펼친 뒤의 그림을 보기에서 고르시오.",
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
        flex: 1,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Text("1"),
                          Container(
                            width: 125,
                            child: Image.file(
                              File(this.widget.exam.directory +
                                  "/back" +
                                  (this.widget.index + 1).toString() +
                                  "_0.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text("2"),
                          Container(
                            width: 125,
                            child: Image.file(
                              File(this.widget.exam.directory +
                                  "/back" +
                                  (this.widget.index + 1).toString() +
                                  "_1.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Text("3"),
                          Container(
                            width: 125,
                            child: Image.file(
                              File(this.widget.exam.directory +
                                  "/back" +
                                  (this.widget.index + 1).toString() +
                                  "_2.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text("4"),
                          Container(
                            width: 125,
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
              flex: 1,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  child: Column(
                    children: [
                      // Problem Question Section
                      Container(
                          width: double.infinity,
                          child: Text(
                            "#${this.widget.index + 1}\n${problemText[this.widget.exam.problemList[this.widget.index].textType]}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          )),
                      Divider(),
                      Container(
                        height: 250,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      Text("1"),
                                      Container(
                                        width: 100,
                                        child: Image.file(
                                          File(this.widget.exam.directory +
                                              "/problem" +
                                              (this.widget.index + 1)
                                                  .toString() +
                                              "_0.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Text("2"),
                                      Container(
                                        width: 100,
                                        child: Image.file(
                                          File(this.widget.exam.directory +
                                              "/problem" +
                                              (this.widget.index + 1)
                                                  .toString() +
                                              "_1.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      Text("3"),
                                      Container(
                                        width: 100,
                                        child: Image.file(
                                          File(this.widget.exam.directory +
                                              "/problem" +
                                              (this.widget.index + 1)
                                                  .toString() +
                                              "_2.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Text("4"),
                                      Container(
                                        width: 100,
                                        child: Image.file(
                                          File(this.widget.exam.directory +
                                              "/problem" +
                                              (this.widget.index + 1)
                                                  .toString() +
                                              "_3.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
