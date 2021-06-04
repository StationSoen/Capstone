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
              NoteBlock3D(
                  index: this.widget.index,
                  exam: this.widget.exam,
                  isVisible: isVisible),
              Divider(),
              // problem Card
              problemPage(
                  this.widget.exam.problemList[this.widget.index].difficulty)
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

  void _onSceneCreated(Scene scene) {
    debugPrint("큐브 시작");
    _scene = scene;
    scene.camera.position.x = 5.56;
    scene.camera.position.z = 7.73;
    scene.camera.position.y = 5.64;

    debugPrint(this.widget.exam.directory);

    create_blocks(
        this.widget.exam.problemList[this.widget.index].problemData[1], scene);

    //_cube = Object(scale: Vector3(30.0, 30.0, 30.0), backfaceCulling: false, fileName: 'assets/cube/cube.obj', isAsset: true);

    debugPrint("큐브 끝");
  }

  late int a;
  @override
  void initState() {
    a = 0;
    print("+++++++++++++" + a.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.isVisible) {
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
      a = a - 1;
      print("=============" + a.toString());
      return Container();
    }
  }
}
