import 'dart:async';
import 'dart:io';

import 'package:capstone/main.dart';
import 'package:capstone/problemPaused.dart';
import 'package:cupertino_progress_bar/cupertino_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import 'exam.dart';

// ignore: deprecated_member_use
List<int> userChoice = List.empty();

class ProblemPage extends StatefulWidget {
  Exam exam;

  ProblemPage({required this.exam});

  @override
  _ProblemPageState createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  SwiperController swiperController = new SwiperController();
  int indexPlus = 1;

  /// counter second - add 1 in 1 second.
  int second = 0;

  late int numberProblem;
  late int maxSecond;
  bool isPaused = true;

  _showCupertinoDialog() {
    showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              title: new Text("시간 초과"),
              content: new Text("설정된 시간이 완료되었습니다."),
              actions: <Widget>[
                CupertinoButton(
                  child: Text('제출'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/scorePage');
                  },
                )
              ],
            ));
  }

  late Timer timer;

  @override
  void initState() {
    super.initState();

    // data initialize for this.widget.exam
    maxSecond = this.widget.exam.remainSeconds;
    numberProblem = this.widget.exam.numberOfProblems;

    // timer .. add 1 per 1 second & stop when second >= maxSecond.
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (isPaused) {
          second++;
        }
      });
      if (second >= maxSecond) {
        timer.cancel();
        _showCupertinoDialog();
      }
      // debugPrint("$second");
    });
  }

  @override
  void dispose() {
    // cancel timer
    timer.cancel();
    super.dispose();
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
            heroTag: "problemPage",
            transitionBetweenRoutes: false,
            // Strange...

            middle: Stack(
              overflow: Overflow.visible,
              children: [
                Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$indexPlus / $numberProblem"),
                      Row(children: [
                        Text("${(second / 60).toInt().toString().padLeft(2, "0")}:${(second % 60).toInt().toString().padLeft(2, "0")} " +
                            "/ ${(maxSecond / 60).toInt().toString().padLeft(2, "0")}:${(maxSecond % 60).toInt().toString().padLeft(2, "0")}"),
                        CupertinoButton(
                            padding: EdgeInsets.only(
                              left: 10,
                            ),
                            onPressed: () {
                              debugPrint("Tapped!");
                              isPaused = false;
                              _gotoIndex(context);
                            },
                            child: Icon(
                              CupertinoIcons.pause_fill,
                              color: Colors.red,
                            ))
                      ])
                    ],
                  ),
                )),
                Positioned(
                  left: -8,
                  right: -8,
                  bottom: 0,
                  child: CupertinoProgressBar(
                    value: second / maxSecond,
                    valueColor: Colors.red,
                    trackColor: null,
                  ),
                ),
              ],
            ),
            automaticallyImplyLeading: false,
          ),
          child: Container(
              padding: EdgeInsets.only(top: 70),
              width: double.infinity,
              child: Swiper(
                controller: swiperController,
                itemCount: examList[0].numberOfProblems,
                loop: false,
                itemBuilder: (BuildContext context, int index) {
                  return ProblemCard(
                    index: index,
                    swiperController: swiperController,
                    maxIndex: examList[0].numberOfProblems - 1,
                    directory: examList[0].directory,
                  );
                },
                onIndexChanged: (int i) {
                  setState(() {
                    indexPlus = i + 1;
                  });
                },
              ))),
    );
  }

  _gotoIndex(BuildContext buildContext) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ProblemPausedPage()));
    if (result != null) {
      swiperController.move(result);
    }
    isPaused = true;
  }
}

class ProblemCard extends StatefulWidget {
  String directory;
  late double answerSize = 125;
  late int index;
  late SwiperController swiperController;
  late int maxIndex;

  ProblemCard(
      {required this.index,
      required this.swiperController,
      required this.maxIndex,
      required this.directory});

  @override
  _ProblemCardState createState() => _ProblemCardState();
}

class _ProblemCardState extends State<ProblemCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      child: Column(
        children: [
          // Problem Question Section
          Container(
              width: double.infinity,
              child:
                  Text("#${this.widget.index + 1}\n전개도를 보고 해당하는 입체도형을 고르시오.")),
          Divider(),
          Container(
            height: 200,
            width: 200,
            child: Image.file(
              File(this.widget.directory +
                  "/problem" +
                  (this.widget.index + 1).toString() +
                  ".png"),
              fit: BoxFit.contain,
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
                    onPressed: () {
                      debugPrint("01 select!");
                      debugPrint(
                          "${this.widget.index} : ${this.widget.maxIndex}");
                      if (!(this.widget.index == this.widget.maxIndex)) {
                        this.widget.swiperController.next();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      height: this.widget.answerSize,
                      width: this.widget.answerSize,
                      child: Image.file(
                        File(this.widget.directory +
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
                    onPressed: () {
                      debugPrint("02 select!");
                      if (!(this.widget.index == this.widget.maxIndex)) {
                        this.widget.swiperController.next();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      height: this.widget.answerSize,
                      width: this.widget.answerSize,
                      child: Image.file(
                        File(this.widget.directory +
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                CupertinoButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    debugPrint("03 select!");
                    if (!(this.widget.index == this.widget.maxIndex)) {
                      this.widget.swiperController.next();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    height: this.widget.answerSize,
                    width: this.widget.answerSize,
                    child: Image.file(
                      File(this.widget.directory +
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
                  onPressed: () {
                    debugPrint("04 select!");
                    if (!(this.widget.index == this.widget.maxIndex)) {
                      this.widget.swiperController.next();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    height: this.widget.answerSize,
                    width: this.widget.answerSize,
                    child: Image.file(
                      File(this.widget.directory +
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
    );
  }
}
