import 'dart:io';
import 'dart:ui';

import 'package:plp/ui/LoadingPage.dart';
import 'package:plp/ui/component.dart';
import 'package:plp/visual/load.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'dart:ui' as UI;
import 'dart:ui';
import 'SplashScreen.dart';
import '../exam.dart';
import '../logic/stack_blocks.dart';

void create_block(Scene scene, double x, double y, double z, int colornum) {
  if (colornum == 0) {
    return;
  } else if (colornum == 1) {
    var cube = Object(
        scale: Vector3(2, 2, 2),
        position: Vector3(x, z, y),
        backfaceCulling: false,
        fileName: 'assets/block/Rcube.obj',
        isAsset: true);
    scene.world.add(cube);
  } else if (colornum == 2) {
    var cube = Object(
        scale: Vector3(2, 2, 2),
        position: Vector3(x, z, y),
        backfaceCulling: false,
        fileName: 'assets/block/Ycube.obj',
        isAsset: true);
    scene.world.add(cube);
  } else if (colornum == 3) {
    var cube = Object(
        scale: Vector3(2, 2, 2),
        position: Vector3(x, z, y),
        backfaceCulling: false,
        fileName: 'assets/block/Bcube.obj',
        isAsset: true);
    scene.world.add(cube);
  }
}

void create_blocks(var block, Scene scene) {
  for (int i = 0; i < block[0][0].length; i++) {
    for (int j = 0; j < block[0].length; j++) {
      for (int k = 0; k < block.length; k++) {
        create_block(
            scene, k.toDouble(), j.toDouble(), i.toDouble(), block[k][j][i]);
      }
    }
  }
}

class Block3D extends StatefulWidget {
  late Exam exam;
  late int index;
  late double answerSize = 125;
  Block3D({required this.exam, required this.index});

  @override
  _Block3DState createState() => _Block3DState();
}

class _Block3DState extends State<Block3D> with SingleTickerProviderStateMixin {
  bool isLoadComplete = false;
  @override
  void initState() {
    super.initState();

    if (this.widget.exam.problemList[this.widget.index].difficulty == 0) {
      blockNum = 3;
    } else {
      blockNum = 4;
    }

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
    "다음의 도형을 완성하기 위해, 추가로 필요한 블럭으로 알맞은 것을 고르시오.",
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

  Widget problemPage(int difficulty) {
    if (difficulty == 0) {
      // Block Stack - Easy
      return Container(
          height: 250,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                // color: Colors.black,
                width: 125,
                child: Image.file(
                  File(this.widget.exam.directory +
                      "/problem" +
                      (this.widget.index + 1).toString() +
                      "_0.png"),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                // color: Colors.black,
                width: 125,
                child: Image.file(
                  File(this.widget.exam.directory +
                      "/problem" +
                      (this.widget.index + 1).toString() +
                      "_1.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ));
    } else {
      return Container(
          height: 250,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // color: Colors.black,
                width: 140,
                child: Image.file(
                  File(this.widget.exam.directory +
                      "/problem" +
                      (this.widget.index + 1).toString() +
                      "_0.png"),
                  fit: BoxFit.cover,
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    // color: Colors.black,
                    width: 100,
                    child: Image.file(
                      File(this.widget.exam.directory +
                          "/problem" +
                          (this.widget.index + 1).toString() +
                          "_1.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: 100,
                    child: Image.file(
                      File(this.widget.exam.directory +
                          "/problem" +
                          (this.widget.index + 1).toString() +
                          "_2.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              )
            ],
          ));
    }
  }

  bool isVisible = true;

  late int blockNum;

  int blockIndex = 0;

  List<String> blockButton = ["전체 블럭", '노란 블럭', "파란 블럭", "빨간 블럭"];

  List<Widget> noteButton(int number) {
    List<Widget> result = [];
    for (int i = 0; i < number; i++) {
      result.add(Expanded(
        child: CupertinoButton(
          padding: EdgeInsets.all(0),
          child: Container(child: Text(blockButton[i])),
          onPressed: () {
            setState(() {
              blockIndex = 0;
              print("change blockIndex 0! $blockIndex");
            });
            setState(() {
              blockIndex = i;
              print("change blockIndex $blockIndex");
            });
          },
        ),
      ));
    }

    return result;
  }

  Widget blockSelect(int value, int index, Exam exam, bool isVisible) {
    if (isVisible) {
      if (value == 0) {
        return Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(26),
                    bottomRight: Radius.circular(26)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.17),
                    offset: Offset(0.0, 3.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NoteBlock01(index: index, exam: exam),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: noteButton(blockNum),
                  )
                ],
              ),
            ));
      } else if (value == 1) {
        return Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(26),
                    bottomRight: Radius.circular(26)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.17),
                    offset: Offset(0.0, 3.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NoteBlock02(index: index, exam: exam),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: noteButton(blockNum),
                  )
                ],
              ),
            ));
      } else if (value == 2) {
        return Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(26),
                    bottomRight: Radius.circular(26)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.17),
                    offset: Offset(0.0, 3.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NoteBlock03(index: index, exam: exam),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: noteButton(blockNum),
                  )
                ],
              ),
            ));
      } else {
        return Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(26),
                    bottomRight: Radius.circular(26)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.17),
                    offset: Offset(0.0, 3.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NoteBlock04(index: index, exam: exam),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: noteButton(blockNum),
                  )
                ],
              ),
            ));
      }
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("World!");
    if (isLoadComplete == false) {
      return LoadingScreen();
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
              child: Text(
                "오답노트",
                style: TextStyle(fontWeight: FontWeight.w600),
              )),
          middle: Text(
              "오답노트 : ${(this.widget.index + 1).toString().padLeft(2, '0')}번 문제"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              blockSelect(
                  blockIndex, this.widget.index, this.widget.exam, isVisible),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: double.infinity,
                            child: Text(
                              "#${this.widget.index + 1}\n${problemText[this.widget.exam.problemList[this.widget.index].textType]}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            )),
                        // problem Card
                        problemPage(this
                            .widget
                            .exam
                            .problemList[this.widget.index]
                            .difficulty),
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
}

class NoteBlock01 extends StatefulWidget {
  Exam exam;
  int index;

  NoteBlock01({
    required this.index,
    required this.exam,
  });

  @override
  _NoteBlock01State createState() => _NoteBlock01State();
}

class _NoteBlock01State extends State<NoteBlock01> {
  double camera_x = 5.56;
  double camera_y = 7.73;
  double camera_z = 5.64;

  late Scene _scene;
  Object? _cube;

  void _onSceneCreated(Scene scene) {
    debugPrint("큐브 시작");
    _scene = scene;
    scene.camera.position.x = camera_x;
    scene.camera.position.z = camera_y;
    scene.camera.position.y = camera_z;

    debugPrint(this.widget.exam.directory);

    create_blocks(
        this.widget.exam.problemList[this.widget.index].problemData[0], scene);

    //_cube = Object(scale: Vector3(30.0, 30.0, 30.0), backfaceCulling: false, fileName: 'assets/cube/cube.obj', isAsset: true);

    debugPrint("큐브 끝");
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 10,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                color: Colors.grey,
                child: Container(
                  child: Cube(onSceneCreated: _onSceneCreated),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoteBlock02 extends StatefulWidget {
  Exam exam;
  int index;

  NoteBlock02({required this.index, required this.exam});

  @override
  _NoteBlock02State createState() => _NoteBlock02State();
}

class _NoteBlock02State extends State<NoteBlock02> {
  double camera_x = 5.56;
  double camera_y = 7.73;
  double camera_z = 5.64;

  late Scene _scene;
  Object? _cube;

  void _onSceneCreated(Scene scene) {
    debugPrint("큐브 시작");
    _scene = scene;
    scene.camera.position.x = camera_x;
    scene.camera.position.z = camera_y;
    scene.camera.position.y = camera_z;

    debugPrint(this.widget.exam.directory);

    create_blocks(
        this.widget.exam.problemList[this.widget.index].problemData[1], scene);

    //_cube = Object(scale: Vector3(30.0, 30.0, 30.0), backfaceCulling: false, fileName: 'assets/cube/cube.obj', isAsset: true);

    debugPrint("큐브 끝");
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 10,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                color: Colors.grey,
                child: Container(
                  child: Cube(onSceneCreated: _onSceneCreated),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoteBlock03 extends StatefulWidget {
  Exam exam;
  int index;

  NoteBlock03({required this.index, required this.exam});

  @override
  _NoteBlock03State createState() => _NoteBlock03State();
}

class _NoteBlock03State extends State<NoteBlock03> {
  double camera_x = 5.56;
  double camera_y = 7.73;
  double camera_z = 5.64;

  late Scene _scene;
  Object? _cube;

  void _onSceneCreated(Scene scene) {
    debugPrint("큐브 시작");
    _scene = scene;
    scene.camera.position.x = camera_x;
    scene.camera.position.z = camera_y;
    scene.camera.position.y = camera_z;

    debugPrint(this.widget.exam.directory);

    create_blocks(
        this.widget.exam.problemList[this.widget.index].problemData[2], scene);

    //_cube = Object(scale: Vector3(30.0, 30.0, 30.0), backfaceCulling: false, fileName: 'assets/cube/cube.obj', isAsset: true);

    debugPrint("큐브 끝");
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 10,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                color: Colors.grey,
                child: Container(
                  child: Cube(onSceneCreated: _onSceneCreated),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoteBlock04 extends StatefulWidget {
  Exam exam;
  int index;

  NoteBlock04({required this.index, required this.exam});

  @override
  _NoteBlock04State createState() => _NoteBlock04State();
}

class _NoteBlock04State extends State<NoteBlock04> {
  double camera_x = 5.56;
  double camera_y = 7.73;
  double camera_z = 5.64;

  late Scene _scene;
  Object? _cube;

  void _onSceneCreated(Scene scene) {
    debugPrint("큐브 시작");
    _scene = scene;
    scene.camera.position.x = camera_x;
    scene.camera.position.z = camera_y;
    scene.camera.position.y = camera_z;

    debugPrint(this.widget.exam.directory);

    create_blocks(
        this.widget.exam.problemList[this.widget.index].problemData[3], scene);

    //_cube = Object(scale: Vector3(30.0, 30.0, 30.0), backfaceCulling: false, fileName: 'assets/cube/cube.obj', isAsset: true);

    debugPrint("큐브 끝");
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 10,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                color: Colors.grey,
                child: Container(
                  child: Cube(onSceneCreated: _onSceneCreated),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
