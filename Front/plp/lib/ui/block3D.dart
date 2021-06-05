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
              NoteBlock3D(
                  index: this.widget.index,
                  exam: this.widget.exam,
                  isVisible: isVisible),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: double.infinity,
                            child: Text(
                              "#${this.widget.index + 1}\n${problemText[this.widget.exam.problemList[this.widget.index].textType]}",
                              style: TextStyle(fontSize: 16),
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

class NoteBlock3D extends StatefulWidget {
  bool isVisible;
  Exam exam;
  int index;

  NoteBlock3D(
      {required this.index, required this.exam, required this.isVisible});

  @override
  _NoteBlock3DState createState() => _NoteBlock3DState();
}

class _NoteBlock3DState extends State<NoteBlock3D>
    with SingleTickerProviderStateMixin {
  late Scene _scene;
  Object? _cube;

  double camera_x = 5.56;
  double camera_y = 7.73;
  double camera_z = 5.64;

  void _onSceneCreated0(Scene scene) {
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

  void _onSceneCreated1(Scene scene) {
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

  void _onSceneCreated2(Scene scene) {
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

  void _onSceneCreated3(Scene scene) {
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

  SceneCreatedCallback returnBlock(int i) {
    if (i == 0) {
      return _onSceneCreated0;
    } else if (i == 1) {
      return _onSceneCreated1;
    } else if (i == 2) {
      return _onSceneCreated2;
    } else if (i == 3) {
      return _onSceneCreated3;
    } else {
      return _onSceneCreated0;
    }
  }

  List<Widget> noteButton(int number) {
    List<Widget> result = [];
    for (int i = 0; i < number; i++) {
      result.add(Expanded(
        child: CupertinoButton(
          padding: EdgeInsets.all(0),
          child: Container(child: Text((i + 1).toString())),
          onPressed: () {
            blockIndex = i;
            setState(() {});
          },
        ),
      ));
    }

    return result;
  }

  int blockIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (this.widget.isVisible) {
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
                    child: Cube(
                      onSceneCreated: returnBlock(blockIndex),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: noteButton(4)),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
