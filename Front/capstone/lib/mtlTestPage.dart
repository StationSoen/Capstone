import 'dart:ui';

import 'package:capstone/load.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'dart:ui' as UI;
import 'dart:ui';
import 'SplashScreen.dart';
import 'exam.dart';
import 'main.dart';

class MtlTestPage extends StatefulWidget {
  late Exam exam;
  late int index;
  MtlTestPage({required this.exam, required this.index});

  @override
  _MtlTestPageState createState() => _MtlTestPageState();
}

class _MtlTestPageState extends State<MtlTestPage>
    with SingleTickerProviderStateMixin {
  late Scene _scene;
  Object? _cube;
  late AnimationController _controller;

  void _onSceneCreated(Scene scene) {
    debugPrint("큐브 시작");
    _scene = scene;
    scene.camera.position.z = 60;

    debugPrint(this.widget.exam.directory);

    _cube = Object(
        scale: Vector3(30.0, 30.0, 30.0),
        fileName: this.widget.exam.directory + '/dice.obj',
        isAsset: false);

    //_cube = Object(scale: Vector3(30.0, 30.0, 30.0), backfaceCulling: false, fileName: 'assets/cube/cube.obj', isAsset: true);

    debugPrint("큐브 끝");
    scene.world.add(_cube!);
    debugPrint("큐브 추가");
  }

  @override
  void initState() {
    super.initState();

    // 오답노트용임

    _controller = AnimationController(
        duration: Duration(milliseconds: 30000), vsync: this)
      ..addListener(() {
        if (_cube != null) {
          //_cube!.rotation.y = _controller.value * 360;
          _cube!.updateTransform();
          _scene.updateTexture();
        }
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future loadMinCode() async {
    await loadfile('dice.obj', this.widget.exam.directory);
    await loadmtlfile(
        'dice.mtl', this.widget.index + 1, this.widget.exam.directory);
    debugPrint(
        'mtl num은 ${this.widget.index + 1}, mtl 경로는 ${this.widget.exam.directory}');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadMinCode(),
      builder: (context, snapshot) {
        // Once complete, show applications.
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: CupertinoNavigationBar(
              middle: Text(
                  "오답노트 : ${(this.widget.index + 1).toString().padLeft(2, '0')}번 문제"),
            ),
            body: Container(
              color: Colors.grey,
              child: Cube(
                onSceneCreated: _onSceneCreated,
              ),
            ),
          );
        }

        // if future has error, show error page.
        if (snapshot.hasError) {
          return CupertinoPageScaffold(
            child: Center(child: Text("ERROR!")),
          );
        }

        // else, view splash screen.
        return SplashScreen();
      },
    );
  }
}
