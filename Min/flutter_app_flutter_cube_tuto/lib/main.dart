import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'dart:ui' as UI;
import 'dart:ui';

import 'png.dart';
import 'load.dart';
import 'dev_cube.dart';
import 'problem.dart';



String dir = "";
List<int> answerlist=[];
List<Color?> colorlist=[Colors.red[700], Colors.orange, Colors.pink, Colors.yellow, Colors.black, Colors.lime, Colors.green[600],Colors.blue,Colors.cyan,Colors.indigo,Colors.brown,Colors.purple];//색깔 리스트 길이:12
List<UI.Image> imglist =[]; //숫자 이미지 리스트 길이:9    0~8 숫자, 9~20까지는 문양





void main() async{


  Stopwatch stopwatch = new Stopwatch()..start();
  WidgetsFlutterBinding.ensureInitialized();

  print('1 executed in ${stopwatch.elapsed}');

  await numimgload();
  await shapeimgload();


  print('2 executed in ${stopwatch.elapsed}');

  await loaddirectory('test1');

  print('3 executed in ${stopwatch.elapsed}');



  await loadfile('dice.obj');
  await loadmtlfile('dice.mtl',1);



  print('4 executed in ${stopwatch.elapsed}');


  await makecubeproblem(10,0);

  print('5 executed in ${stopwatch.elapsed}');

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
      body: Center(
        child: Cube(
          onSceneCreated: _onSceneCreated,
        ),
      ),
    );
  }
}
