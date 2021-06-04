import 'dart:io';
import 'dart:ui';

import 'package:plp/visual/load.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'dart:ui' as UI;
import 'dart:ui';
import 'SplashScreen.dart';
import '../exam.dart';

class Cube3D extends StatefulWidget {
  late Exam exam;
  late int index;
  late double answerSize = 125;
  Cube3D({required this.exam, required this.index});

  @override
  _Cube3DState createState() => _Cube3DState();
}

class _Cube3DState extends State<Cube3D> {
  bool isLoadComplete = false;
  @override
  void initState() {
    super.initState();
    loadMinCode().then((value) {
      setState(() {
        isLoadComplete = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future loadMinCode() async {
    await loadfile('dice.obj', this.widget.exam.directory);
    await loadmtlfile(
        'dice.mtl', this.widget.index + 1, this.widget.exam.directory);
    debugPrint(
        'mtl num은 ${this.widget.index + 1}, mtl 경로는 ${this.widget.exam.directory}');
    await Future.delayed(Duration(seconds: 2));
  }

  List<String> problemText = [
    "주어진 전개도를 보고, 일치하는 입체도형을 고르시오.",
    "주어진 전개도를 보고, 일치하지 않는 입체도형을 고르시오.",
    "주어진 도형을 보고, 알맞은 전개도를 고르시오.",
    "주어진 도형을 보고, 알맞지 않은 전개도를 고르시오."
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

  bool isScrollLock = false;
  String locked = "잠금 해제됨";
  ScrollPhysics scrollLock() {
    if (isScrollLock) {
      return NeverScrollableScrollPhysics();
    } else {
      return AlwaysScrollableScrollPhysics();
    }
  }

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    debugPrint("World!");
    if (isLoadComplete == false) {
      return SplashScreen();
    } else {
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
                Note(
                  exam: this.widget.exam,
                  index: this.widget.index,
                  isViisible: isVisible,
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
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
                            width: 200,
                            child: Image.file(
                              File(this.widget.exam.directory +
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CupertinoButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2,
                                            color: checkWrongSelect(
                                                problemList: this
                                                    .widget
                                                    .exam
                                                    .problemList,
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
                                              (this.widget.index + 1)
                                                  .toString() +
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
                                                problemList: this
                                                    .widget
                                                    .exam
                                                    .problemList,
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
                                              (this.widget.index + 1)
                                                  .toString() +
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
          ));
    }
  }
}

class Note extends StatefulWidget {
  bool isViisible;
  Exam exam;
  int index;

  Note({required this.index, required this.exam, required this.isViisible});

  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> with SingleTickerProviderStateMixin {
  late Scene _scene;
  Object? _cube;
  late AnimationController _controller;

  void _onSceneCreated(Scene scene) {
    debugPrint("큐브 시작");
    _scene = scene;
    scene.camera.position.z = 1;

    debugPrint(this.widget.exam.directory);

    _cube = Object(
        backfaceCulling: false,
        // scale: Vector3(60.0, 60.0, 60.0),
        position: Vector3(0, -0.25, 0),
        fileName: this.widget.exam.directory + '/dice.obj',
        isAsset: false);

    //_cube = Object(scale: Vector3(30.0, 30.0, 30.0), backfaceCulling: false, fileName: 'assets/cube/cube.obj', isAsset: true);

    debugPrint("큐브 끝");
    scene.world.add(_cube!);
    debugPrint("큐브 추가");
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
        duration: Duration(milliseconds: 30000), vsync: this)
      ..addListener(() {
        if (_cube != null) {
          // _cube!.rotation.y = _controller.value * 360;
          _cube!.updateTransform();
          _scene.updateTexture();
        }
      })
      ..repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.isViisible) {
      return Expanded(
        flex: 2,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          color: Colors.grey,
          child: Container(
            width: double.infinity,
            child: Cube(
              onSceneCreated: _onSceneCreated,
            ),
          ),
        ),
      );
    } else {
      _controller.dispose();
      return Container();
    }
  }

  @override
  void dispose() {
    print("dispose!");

    super.dispose();
  }
}
