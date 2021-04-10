import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'dart:ui' as UI;
import 'dart:ui';
import 'main.dart';

class MtlTestPage extends StatefulWidget {
  late final String? title = "Hello World!";

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

    debugPrint(dir);

    _cube = Object(
        scale: Vector3(30.0, 30.0, 30.0),
        fileName: dir + '/dice.obj',
        isAsset: false);

    //_cube = Object(scale: Vector3(30.0, 30.0, 30.0), backfaceCulling: false, fileName: 'assets/cube/cube.obj', isAsset: true);

    debugPrint("큐브 끝");
    scene.world.add(_cube!);
    debugPrint("큐브 추가");
  }

  @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Container(
        color: Colors.black,
        child: Cube(
          onSceneCreated: _onSceneCreated,
        ),
      ),
    );
  }
}
