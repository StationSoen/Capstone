import 'dart:async';
import 'dart:io';

import 'package:capstone/main.dart';
import 'package:capstone/ui/problemPaused.dart';
import 'package:capstone/ui/recordPage.dart';
import 'package:cupertino_progress_bar/cupertino_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:hive/hive.dart';

import '../exam.dart';

// ignore: deprecated_member_use
List<int> userChoice = List.empty();

class ProblemPage extends StatefulWidget {
  late Exam exam;

  @override
  _ProblemPageState createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  SwiperController swiperController = new SwiperController();
  int indexPlus = 1;

  /// counter second - add 1 in 1 second.
  int second = 0;
  bool init = true;

  late int numberProblem;
  late int maxSecond;
  bool isPaused = true;

  late Timer timer;

  @override
  void initState() {
    super.initState();

    // timer .. add 1 per 1 second & stop when second >= maxSecond.
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      debugPrint("second in timer : $second / $maxSecond");
      setState(() {
        if (isPaused) {
          second++;
        }
      });
      if (second >= maxSecond) {
        timer.cancel();
        showCupertinoDialog(
            title: "시간 초과",
            content: "설정한 시간이 만료되었습니다.",
            cancel: false,
            exam: this.widget.exam,
            context: context,
            second: this.widget.exam.settingTime);
      }
      // debugPrint("$second");
    });
  }

  @override
  void dispose() {
    // cancel timer
    timer.cancel();
    debugPrint("Timer OUT!");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // extract parameter from NamedPush
    this.widget.exam = ModalRoute.of(context)!.settings.arguments as Exam;

    // initialize second with elapsedTime
    // second를 경과시간으로 초기화함.
    if (init) {
      init = false;
      second = this.widget.exam.elapsedTime;
    }

    // data initialize for this.widget.exam
    maxSecond = this.widget.exam.settingTime;
    numberProblem = this.widget.exam.problemList.length;

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
                              // 일시정지로 들어가면, 경과시간 업데이트
                              this.widget.exam.elapsedTime = second;
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
                itemCount: this.widget.exam.problemList.length,
                loop: false,
                itemBuilder: (BuildContext context, int index) {
                  return ProblemCard(
                    index: index,
                    swiperController: swiperController,
                    maxIndex: this.widget.exam.problemList.length - 1,
                    exam: this.widget.exam,
                    second: second,
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
            builder: (BuildContext context) => ProblemPausedPage(
                  numberOfProblems: this.widget.exam.problemList.length,
                  exam: this.widget.exam,
                  elapsedTime: second,
                )));

    debugPrint(result.toString());
    if (result != null) {
      swiperController.move(result);
    }
    isPaused = true;
  }
}

class ProblemCard extends StatefulWidget {
  late double answerSize = 125;
  late int index;
  late SwiperController swiperController;
  late int maxIndex;

  late Exam exam;

  late int second;

  late int type;

  ProblemCard(
      {required this.index,
      required this.exam,
      required this.swiperController,
      required this.maxIndex,
      required this.second}) {
    this.type = this.exam.problemList[index].problemType;
  }

  @override
  _ProblemCardState createState() => _ProblemCardState();
}

class _ProblemCardState extends State<ProblemCard> {
  /// checkSelect - Change Color to Blue
  Color checkSelect(
      {required List<int> userAnswerList,
      required int index,
      required select}) {
    if (userAnswerList[index] == select) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  List<List<String>> problemText = [
    [
      "주어진 전개도를 보고, 일치하는 입체도형을 고르시오.",
      "주어진 전개도를 보고, 일치하지 않는 입체도형을 고르시오.",
      "주어진 도형을 보고, 알맞은 전개도를 고르시오.",
      "주어진 도형을 보고, 알맞지 않은 전개도를 고르시오."
    ],
    [
      "다음과 같이 종이를 접었을 때, 마지막 종이의 앞면 또는 뒷면으로 알맞은 것을 고르시오.",
      "다음과 같이 종이를 접었을 때, 마지막 종이의 앞면 또는 뒷면으로 알맞지 않은 것을 고르시오.",
    ]
  ];

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
              child: Text(
                  "#${this.widget.index + 1}\n${problemText[this.widget.type][this.widget.exam.problemList[this.widget.index].textType]}")),
          Divider(),
          problemQuestion(this.widget.type),
          Divider(),

          // Problem Answers Section
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  selectButton(0, this.widget.second),
                  selectButton(1, this.widget.second)
                ],
              ),
              SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                selectButton(2, this.widget.second),
                selectButton(3, this.widget.second)
              ])
            ],
          )
        ],
      ),
    );
  }

  Widget problemQuestion(int type) {
    if (type == 0) {
      // Cube Problem
      return Container(
        height: 200,
        width: 200,
        child: Image.file(
          File(this.widget.exam.directory +
              "/problem" +
              (this.widget.index + 1).toString() +
              ".png"),
          fit: BoxFit.contain,
        ),
      );
    } else if (type == 1) {
      // PaperFlod Problem
      return Container(
        height: 200,
        width: double.infinity,
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
      );
    } else {
      return Container(
        child: Text("Something Wrong!"),
      );
    }
  }

  Widget selectButton(int key, int second) {
    return CupertinoButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        debugPrint((key + 1).toString() + "select!");
        setState(() {
          this.widget.exam.userAnswer[this.widget.index] = key;
        });
        if (!(this.widget.index == this.widget.maxIndex)) {
          this.widget.swiperController.next();
        } else {
          showCupertinoDialog(
              title: "마지막 문제",
              content: "마지막 문제입니다.\n제출하시겠습니까?",
              cancel: true,
              exam: this.widget.exam,
              context: context,
              second: second);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: checkSelect(
                  userAnswerList: this.widget.exam.userAnswer,
                  index: this.widget.index,
                  select: key)),
        ),
        height: this.widget.answerSize,
        width: this.widget.answerSize,
        child: Image.file(
          File(this.widget.exam.directory +
              "/example" +
              (this.widget.index + 1).toString() +
              "_" +
              key.toString() +
              ".png"),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

showCupertinoDialog(
    {required String title,
    required String content,
    required bool cancel,
    required Exam exam,
    required BuildContext context,
    required int second}) {
  var completeExamListHive = Hive.box('completeExamList');
  var pausedExamListHive = Hive.box('pausedExamList');
  List<Widget> dialogActions = [
    CupertinoButton(
      child: Text('제출'),
      onPressed: () {
        exam.complete = true;
        exam.elapsedTime = second;

        pausedExamList
            .removeWhere((element) => element.dateCode == exam.dateCode);

        // completeExamList에 값 추가.
        completeExamList.add(exam);

        // Hive에 업데이트.
        completeExamListHive.put('completeExamList', completeExamList);
        pausedExamListHive.put('pausedExamList', pausedExamList);
        Navigator.pushNamedAndRemoveUntil(
            context, '/problemDetailCompletePage', ModalRoute.withName('/'),
            arguments: exam);
      },
    ),
  ];
  if (cancel == true) {
    dialogActions.add(CupertinoButton(
      child: Text(
        '취소',
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ));
  }
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => new CupertinoAlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: dialogActions));
}
