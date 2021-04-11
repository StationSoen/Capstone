import 'main.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as UI;
import 'package:image/image.dart' as IMG;
import 'dart:async';

Future<void> numimgload() async {
  imglist.add(await loadImage('assets/numbers/0.jpg'));
  imglist.add(await loadImage('assets/numbers/1.jpg'));
  imglist.add(await loadImage('assets/numbers/2.jpg'));
  imglist.add(await loadImage('assets/numbers/3.jpg'));
  imglist.add(await loadImage('assets/numbers/4.jpg'));
  imglist.add(await loadImage('assets/numbers/5.jpg'));
  imglist.add(await loadImage('assets/numbers/6.jpg'));
  imglist.add(await loadImage('assets/numbers/7.jpg'));
  imglist.add(await loadImage('assets/numbers/8.jpg'));
}

Future<void> shapeimgload() async {
  imglist.add(await loadImage('assets/shapes/shape00.png'));
  imglist.add(await loadImage('assets/shapes/shape01.png'));
  imglist.add(await loadImage('assets/shapes/shape02.png'));
  imglist.add(await loadImage('assets/shapes/shape03.png'));
  imglist.add(await loadImage('assets/shapes/shape04.png'));
  imglist.add(await loadImage('assets/shapes/shape05.png'));
  imglist.add(await loadImage('assets/shapes/shape06.png'));
  imglist.add(await loadImage('assets/shapes/shape07.png'));
  imglist.add(await loadImage('assets/shapes/shape08.png'));
  imglist.add(await loadImage('assets/shapes/shape09.png'));
  imglist.add(await loadImage('assets/shapes/shape10.png'));
  imglist.add(await loadImage('assets/shapes/shape11.png'));
  imglist.add(await loadImage('assets/shapes/shape12.png'));
  imglist.add(await loadImage('assets/shapes/shape13.png'));
  imglist.add(await loadImage('assets/shapes/shape14.png'));
  imglist.add(await loadImage('assets/shapes/shape15.png'));
  imglist.add(await loadImage('assets/shapes/shape16.png'));
  imglist.add(await loadImage('assets/shapes/shape17.png'));
  imglist.add(await loadImage('assets/shapes/shape18.png'));
}

///앱 내부 폴더의 경로를 불러와 cubedir에 저장하는 함수

///앱 내부 폴더의 경로를 불러와 dir에 저장하는 함수
Future<String> loaddirectory(String testName) async {
  //testcode
  String dir;
  //testcode

// code of read or write file in external storage (SD card)
  final directory = await getApplicationDocumentsDirectory();
  dir = directory.path;
  dir = dir + '/' + testName;
  new Directory(dir).create()
      // The created directory is returned as a Future.
      .then((Directory directory) {
    print(directory.path);
  });
  debugPrint(dir);
  return dir;
}

///assets에 있는 파일을 불러와 앱 내부 폴더에 저장하는 함수
Future<void> loadfile(String fileName, String dir) async {
  ByteData data = await rootBundle.load("assets/cube/" + fileName);
  List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
// code of read or write file in external storage (SD card)

  File('${dir}/' + fileName).writeAsBytes(bytes);

  debugPrint("파일 저장됨");
}

Future<void> loadmtlfile(String fileName, int num, String directory) async {
  //
  String data = await rootBundle.loadString("assets/cube/dice.mtl");
  debugPrint("${data.length}");
  String newdata =
      data.substring(0, 362) + num.toString() + data.substring(363);
  File('${directory}/' + fileName).writeAsStringSync(newdata);

  debugPrint("파일 저장됨");
}

///png를 assets에서 불러와 저장하는 함수, 디버그용
Future<void> loadpng(String directory) async {
  ByteData data = await rootBundle.load("assets/cube/flutter.png");
  List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  File('${directory}/flutter.png').writeAsBytes(bytes);
}

///assets에 있는 이미지를 불러오는 함수
Future<UI.Image> loadImage(imageAssetPath) async {
  final ByteData data = await rootBundle.load(imageAssetPath);
  Uint8List dataUint8List =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  List<int> dataListInt = dataUint8List.cast<int>();
  var image;
  image = IMG.decodeImage(dataListInt);

  final IMG.Image resized = IMG.copyResize(image, width: 130, height: 130);
  final List<int> resizedBytes = IMG.encodePng(resized);
  final Completer<UI.Image> completer = new Completer();
  var tempList = Uint8List.fromList(resizedBytes);
  UI.decodeImageFromList(tempList, (UI.Image img) => completer.complete(img));
  return completer.future;
}
