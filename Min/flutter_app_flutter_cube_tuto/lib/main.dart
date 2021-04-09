import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'dart:ui' as UI;
import 'dart:ui';

import 'png.dart';
import 'load.dart';



String dir = "";
List<UI.Image> imglist =[];






void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  imglist.add(await loadImage('assets/cube/one.jpg'));
  imglist.add(await loadImage('assets/cube/two.jpg'));
  imglist.add(await loadImage('assets/cube/three.jpg'));
  imglist.add(await loadImage('assets/cube/four.jpg'));
  imglist.add(await loadImage('assets/cube/five.jpg'));
  imglist.add(await loadImage('assets/cube/six.jpg'));

  await loaddirectory();
  await drawisopng(1,0,2,0,3,0);
  await drawtemplatepng(0,0,0,0, 1,0,1,90, 2,1,1,180, 3,2,1,270, 4,3,1,180, 5,1,2,0);
  await drawmtlpng(0,90 ,1,0, 2,0, 3,180, 4,270, 5,0);


  //await loadpng();
  await loadfile('dice.obj');
  await loadfile('dice.mtl');


  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cube',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Flutter Cube Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late Scene _scene;
  Object? _cube;
  late AnimationController _controller;

  void _onSceneCreated(Scene scene){
    debugPrint("큐브 시작");
    _scene = scene;
    scene.camera.position.z = 60;

    debugPrint(dir);


    _cube = Object(scale: Vector3(30.0, 30.0, 30.0), fileName: dir+'/dice.obj', isAsset: false);

    //_cube = Object(scale: Vector3(30.0, 30.0, 30.0), backfaceCulling: false, fileName: 'assets/cube/cube.obj', isAsset: true);

    debugPrint("큐브 끝");
    scene.world.add(_cube!);
    debugPrint("큐브 추가");
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: Duration(milliseconds: 30000), vsync: this)


      ..addListener(() {
        if (_cube != null) {
          _cube!.rotation.y = _controller.value * 360;
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
      body: Center(
        child: Cube(
          onSceneCreated: _onSceneCreated,
        ),
      ),
    );
  }
}
