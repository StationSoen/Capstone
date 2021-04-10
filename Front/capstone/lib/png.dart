import 'main.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as UI;
import 'dart:math';

void rotate(Canvas canvas, double cx, double cy, double angle) {
  canvas.translate(cx, cy);
  canvas.rotate(angle);
  canvas.translate(-cx, -cy);
}

Future<void> saveImage(String fileName, ByteData image) async {
  await File('${dir}/${fileName}.png').writeAsBytes(image.buffer.asInt8List());
}

///등각투영도를 그리는 함수
Future<void> drawisopng(String name, int topimage, int toprotate, int leftimage,
    int leftrotate, int rightimage, int rightrotate) async {
  var recorder = new UI.PictureRecorder();
  final canvas = new Canvas(recorder,
      new Rect.fromPoints(new Offset(50, 190), new Offset(260.0, 310.0)));

  List<double> topdown = [
    0.866,
    0.5,
    0,
    0,
    -0.86572461,
    0.500115,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1
  ];
  List<double> right = [
    0.866,
    -0.499682,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1
  ];
  List<double> left = [
    0.866,
    0.499682,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1
  ];
  var topdown_matrix4 = Float64List.fromList(topdown);
  var right_matrix4 = Float64List.fromList(right);
  var left_matrix4 = Float64List.fromList(left);
  var paint = Paint();
  paint.color = Colors.black;
  paint.strokeWidth = 3;
  paint.style = PaintingStyle.stroke;

  //top 그림
  canvas.save();
  canvas.transform(topdown_matrix4);
  canvas.drawRect(Offset(100, -50) & Size(130, 130), paint);
  rotate(canvas, 165, 15, toprotate * pi / 180);
  canvas.drawImage(imglist[topimage], new Offset(100, -50.0), paint);
  canvas.restore();

  //left 그림
  canvas.save();
  canvas.transform(left_matrix4);
  canvas.drawRect(Offset(20, 80) & Size(130, 130), paint);
  rotate(canvas, 85, 145, leftrotate * pi / 180);
  canvas.drawImage(imglist[leftimage], new Offset(20, 80), paint);
  canvas.restore();

  //right 그림
  canvas.save();
  canvas.transform(right_matrix4);
  canvas.drawRect(Offset(150, 230) & Size(130, 130), paint);
  rotate(canvas, 215, 295, rightrotate * pi / 180);
  canvas.drawImage(imglist[rightimage], new Offset(150, 230.0), paint);
  canvas.restore();

  final picture = recorder.endRecording();
  UI.Image img = await picture.toImage(260, 310);
  final abc = await img.toByteData(format: UI.ImageByteFormat.png);
  if (abc != null) // ?는 Nullable 이기 때문에 nonNullable로 바꿔줘야됨
  {
    await saveImage(name, abc);
    debugPrint("저장됨");
  }
}

///컬러 등각투영도를 png로 만드는 함수
Future<void> drawcolorisopng(
    String name, final topcolor, final leftcolor, final rightcolor) async {
  var recorder = new UI.PictureRecorder();
  final canvas = new Canvas(recorder,
      new Rect.fromPoints(new Offset(50, 190), new Offset(260.0, 310.0)));

  List<double> topdown = [
    0.866,
    0.5,
    0,
    0,
    -0.86572461,
    0.500115,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1
  ];
  List<double> right = [
    0.866,
    -0.499682,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1
  ];
  List<double> left = [
    0.866,
    0.499682,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1
  ];
  var topdown_matrix4 = Float64List.fromList(topdown);
  var right_matrix4 = Float64List.fromList(right);
  var left_matrix4 = Float64List.fromList(left);
  var paint = Paint();

  paint.strokeWidth = 2;
  paint.style = PaintingStyle.fill;

  paint.color = topcolor;
  //top 그림
  canvas.save();
  canvas.transform(topdown_matrix4);
  canvas.drawRect(Offset(100, -50) & Size(130, 130), paint);
  canvas.restore();

  paint.color = leftcolor;
  //left 그림
  canvas.save();
  canvas.transform(left_matrix4);
  canvas.drawRect(Offset(20, 80) & Size(130, 130), paint);
  canvas.restore();

  paint.color = rightcolor;
  //right 그림
  canvas.save();
  canvas.transform(right_matrix4);
  canvas.drawRect(Offset(150, 230) & Size(130, 130), paint);
  canvas.restore();

  final picture = recorder.endRecording();
  UI.Image img = await picture.toImage(260, 310);
  final abc = await img.toByteData(format: UI.ImageByteFormat.png);
  if (abc != null) // ?는 Nullable 이기 때문에 nonNullable로 바꿔줘야됨
  {
    await saveImage(name, abc);
    debugPrint("저장됨");
  }
}

///flutter cube를 위한 png를 그려주는 함수
Future<void> drawmtlpng(
    String name,
    int image1,
    int rotate1,
    int image2,
    int rotate2,
    int image3,
    int rotate3,
    int image4,
    int rotate4,
    int image5,
    int rotate5,
    int image6,
    int rotate6) async {
  var recorder = new UI.PictureRecorder();
  final canvas = new Canvas(recorder,
      new Rect.fromPoints(new Offset(0.0, 0.0), new Offset(390.0, 260.0)));

  var paint = Paint();
  paint.color = Colors.white;
  paint.strokeWidth = 2;
  paint.style = PaintingStyle.stroke;

  canvas.save();
  rotate(canvas, 65, 65, rotate1 * pi / 180);
  canvas.drawRect(Offset(0, 0) & Size(130, 130), paint);
  canvas.drawImage(imglist[image1], new Offset(0.0, 0.0), paint);
  canvas.restore();

  canvas.save();
  rotate(canvas, 195, 65, rotate2 * pi / 180);
  canvas.drawRect(Offset(130, 0) & Size(130, 130), paint);
  canvas.drawImage(imglist[image2], new Offset(130, 0.0), paint);
  canvas.restore();

  canvas.save();
  rotate(canvas, 325, 65, rotate3 * pi / 180);
  canvas.drawRect(Offset(260, 0) & Size(130, 130), paint);
  canvas.drawImage(imglist[image3], new Offset(260, 0.0), paint);
  canvas.restore();

  canvas.save();
  rotate(canvas, 65, 195, rotate4 * pi / 180);
  canvas.drawRect(Offset(0, 130) & Size(130, 130), paint);
  canvas.drawImage(imglist[image4], new Offset(0, 130), paint);
  canvas.restore();

  canvas.save();
  rotate(canvas, 195, 195, rotate5 * pi / 180);
  canvas.drawRect(Offset(130, 130) & Size(130, 130), paint);
  canvas.drawImage(imglist[image5], new Offset(130, 130), paint);
  canvas.restore();

  canvas.save();
  rotate(canvas, 325, 195, rotate6 * pi / 180);
  canvas.drawRect(Offset(260, 130) & Size(130, 130), paint);
  canvas.drawImage(imglist[image6], new Offset(260, 130), paint);
  canvas.restore();

  final picture = recorder.endRecording();
  UI.Image img = await picture.toImage(390, 260);
  final abc = await img.toByteData(format: UI.ImageByteFormat.png);
  if (abc != null) // ?는 Nullable 이기 때문에 nonNullable로 바꿔줘야됨
  {
    await saveImage(name, abc);
  }
}

///flutter cube를 위한 컬러 png를 그려주는 함수
Future<void> drawcolormtlpng(String name, final color1, final color2,
    final color3, final color4, final color5, final color6) async {
  var recorder = new UI.PictureRecorder();
  final canvas = new Canvas(recorder,
      new Rect.fromPoints(new Offset(0.0, 0.0), new Offset(390.0, 260.0)));

  var paint = Paint();
  paint.color = Colors.white;
  paint.strokeWidth = 2;
  paint.style = PaintingStyle.fill;

  paint.color = color1;
  canvas.drawRect(Offset(0, 0) & Size(130, 130), paint);

  paint.color = color2;
  canvas.drawRect(Offset(130, 0) & Size(130, 130), paint);

  paint.color = color3;
  canvas.drawRect(Offset(260, 0) & Size(130, 130), paint);

  paint.color = color4;
  canvas.drawRect(Offset(0, 130) & Size(130, 130), paint);

  paint.color = color5;
  canvas.drawRect(Offset(130, 130) & Size(130, 130), paint);

  paint.color = color6;
  canvas.drawRect(Offset(260, 130) & Size(130, 130), paint);

  final picture = recorder.endRecording();
  UI.Image img = await picture.toImage(390, 260);
  final abc = await img.toByteData(format: UI.ImageByteFormat.png);
  if (abc != null) // ?는 Nullable 이기 때문에 nonNullable로 바꿔줘야됨
  {
    await saveImage(name, abc);
  }
}

///전개도이미지를 그려주는 함수
Future<void> drawtemplatepng(
    String name,
    int image1,
    int x1,
    int y1,
    int rotate1,
    int image2,
    int x2,
    int y2,
    int rotate2,
    int image3,
    int x3,
    int y3,
    int rotate3,
    int image4,
    int x4,
    int y4,
    int rotate4,
    int image5,
    int x5,
    int y5,
    int rotate5,
    int image6,
    int x6,
    int y6,
    int rotate6) async {
  var recorder = new UI.PictureRecorder();
  final canvas = new Canvas(recorder,
      new Rect.fromPoints(new Offset(0.0, 0.0), new Offset(652, 392.0)));

  double rectsize = 130;
  var paint = Paint();
  paint.color = Colors.black;
  paint.strokeWidth = 3;
  paint.style = PaintingStyle.stroke;

  canvas.save();
  rotate(canvas, x1 * rectsize + rectsize / 2 + 1,
      y1 * rectsize + rectsize / 2 + 1, rotate1 * pi / 180);
  canvas.drawRect(
      Offset(x1 * rectsize + 1, y1 * rectsize + 1) & Size(rectsize, rectsize),
      paint);
  canvas.drawImage(
      imglist[image1], new Offset(x1 * rectsize + 1, y1 * rectsize + 1), paint);
  canvas.restore();

  canvas.save();
  rotate(canvas, x2 * rectsize + rectsize / 2 + 1,
      y2 * rectsize + rectsize / 2 + 1, rotate2 * pi / 180);
  canvas.drawRect(
      Offset(x2 * rectsize + 1, y2 * rectsize + 1) & Size(rectsize, rectsize),
      paint);
  canvas.drawImage(
      imglist[image2], new Offset(x2 * rectsize + 1, y2 * rectsize + 1), paint);
  canvas.restore();

  canvas.save();
  rotate(canvas, x3 * rectsize + rectsize / 2 + 1,
      y3 * rectsize + rectsize / 2 + 1, rotate3 * pi / 180);
  canvas.drawRect(
      Offset(x3 * rectsize + 1, y3 * rectsize + 1) & Size(rectsize, rectsize),
      paint);
  canvas.drawImage(
      imglist[image3], new Offset(x3 * rectsize + 1, y3 * rectsize + 1), paint);
  canvas.restore();

  canvas.save();
  rotate(canvas, x4 * rectsize + rectsize / 2 + 1,
      y4 * rectsize + rectsize / 2 + 1, rotate4 * pi / 180);
  canvas.drawRect(
      Offset(x4 * rectsize + 1, y4 * rectsize + 1) & Size(rectsize, rectsize),
      paint);
  canvas.drawImage(
      imglist[image4], new Offset(x4 * rectsize + 1, y4 * rectsize + 1), paint);
  canvas.restore();

  canvas.save();
  rotate(canvas, x5 * rectsize + rectsize / 2 + 1,
      y5 * rectsize + rectsize / 2 + 1, rotate5 * pi / 180);
  canvas.drawRect(
      Offset(x5 * rectsize + 1, y5 * rectsize + 1) & Size(rectsize, rectsize),
      paint);
  canvas.drawImage(
      imglist[image5], new Offset(x5 * rectsize + 1, y5 * rectsize + 1), paint);
  canvas.restore();

  canvas.save();
  rotate(canvas, x6 * rectsize + rectsize / 2 + 1,
      y6 * rectsize + rectsize / 2 + 1, rotate6 * pi / 180);
  canvas.drawRect(
      Offset(x6 * rectsize + 1, y6 * rectsize + 1) & Size(rectsize, rectsize),
      paint);
  canvas.drawImage(
      imglist[image6], new Offset(x6 * rectsize + 1, y6 * rectsize + 1), paint);
  canvas.restore();

  final picture = recorder.endRecording();
  UI.Image img = await picture.toImage(652, 392);
  final abc = await img.toByteData(format: UI.ImageByteFormat.png);
  if (abc != null) // ?는 Nullable 이기 때문에 nonNullable로 바꿔줘야됨
  {
    await saveImage(name, abc);
    debugPrint("저장됨");
  }
}

///컬러 전개도이미지를 그려주는 함수
Future<void> drawcolortemplatepng(
    String name,
    final color1,
    int x1,
    int y1,
    final color2,
    int x2,
    int y2,
    final color3,
    int x3,
    int y3,
    final color4,
    int x4,
    int y4,
    final color5,
    int x5,
    int y5,
    final color6,
    int x6,
    int y6) async {
  var recorder = new UI.PictureRecorder();
  final canvas = new Canvas(recorder,
      new Rect.fromPoints(new Offset(0.0, 0.0), new Offset(652, 392.0)));

  double rectsize = 130;
  var paint = Paint();
  paint.color = Colors.black;
  paint.strokeWidth = 3;
  paint.style = PaintingStyle.fill;

  paint.color = color1;
  canvas.drawRect(
      Offset(x1 * rectsize + 1, y1 * rectsize + 1) & Size(rectsize, rectsize),
      paint);

  paint.color = color2;
  canvas.drawRect(
      Offset(x2 * rectsize + 1, y2 * rectsize + 1) & Size(rectsize, rectsize),
      paint);

  paint.color = color3;
  canvas.drawRect(
      Offset(x3 * rectsize + 1, y3 * rectsize + 1) & Size(rectsize, rectsize),
      paint);

  paint.color = color4;
  canvas.drawRect(
      Offset(x4 * rectsize + 1, y4 * rectsize + 1) & Size(rectsize, rectsize),
      paint);

  paint.color = color5;
  canvas.drawRect(
      Offset(x5 * rectsize + 1, y5 * rectsize + 1) & Size(rectsize, rectsize),
      paint);

  paint.color = color6;
  canvas.drawRect(
      Offset(x6 * rectsize + 1, y6 * rectsize + 1) & Size(rectsize, rectsize),
      paint);

  final picture = recorder.endRecording();
  UI.Image img = await picture.toImage(652, 392);
  final abc = await img.toByteData(format: UI.ImageByteFormat.png);
  if (abc != null) // ?는 Nullable 이기 때문에 nonNullable로 바꿔줘야됨
  {
    await saveImage(name, abc);
    debugPrint("저장됨");
  }
}
