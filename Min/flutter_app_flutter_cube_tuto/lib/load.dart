import 'main.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as UI;
import 'package:image/image.dart' as IMG;
import 'dart:async';

///앱 내부 폴더의 경로를 불러와 dir에 저장하는 함수
Future<void> loaddirectory() async
{
  final directory = await getApplicationDocumentsDirectory();
  dir = directory.path;
  debugPrint(dir);
}

///assets에 있는 파일을 불러와 앱 내부 폴더에 저장하는 함수
Future<void> loadfile(String fileName) async {
  ByteData data = await rootBundle.load("assets/cube/"+fileName);
  List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  File('${dir}/'+fileName).writeAsBytes(bytes);

  debugPrint("파일 저장됨");
}





///png를 assets에서 불러와 저장하는 함수, 디버그용
Future<void> loadpng() async {
  ByteData data = await rootBundle.load("assets/cube/flutter.png");
  List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  File('${dir}/flutter.png').writeAsBytes(bytes);
}

///assets에 있는 이미지를 불러오는 함수
Future<UI.Image> loadImage( imageAssetPath ) async {

  final ByteData data = await rootBundle.load(imageAssetPath);
  Uint8List dataUint8List = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  List<int> dataListInt = dataUint8List.cast<int>();
  var image;
  image = IMG.decodeImage(dataListInt);


  final IMG.Image resized = IMG.copyResize(image, width: 130,height: 130);
  final List<int> resizedBytes = IMG.encodePng(resized);
  final Completer<UI.Image> completer = new Completer();
  var tempList=Uint8List.fromList(resizedBytes);
  UI.decodeImageFromList(tempList, (UI.Image img) => completer.complete(img));
  return completer.future;
}
