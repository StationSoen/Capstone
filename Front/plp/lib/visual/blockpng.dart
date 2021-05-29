import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as UI;
import 'dart:math';
import 'package:path_drawing/path_drawing.dart';
import 'package:plp/logic/stack_blocks.dart';

Future<void> saveImage(
    String fileName, ByteData image, String directory) async {
  await File('${directory}/${fileName}.png')
      .writeAsBytes(image.buffer.asInt8List());
  // debugPrint('${directory}/${fileName}.png');

  // await File('${dir}/${fileName}.png').writeAsBytes(image.buffer.asInt8List());
}

List<double> topdown = [
  0.906,
  0.423,
  0,
  0,
  -0.922,
  0.429,
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
  0.90628064,
  -0.4221449,
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

List<double> left = [0.906, 0.422196, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];

void dimetric_cube(
    Canvas canvas, Paint paint, double x, double y, double z, int colornum) {
  List<Color> mycolorlist = [
    Colors.red[700]!,

    Colors.red[300]!, //1
    Colors.red,
    Colors.red[700]!,

    Colors.yellow[300]!,
    Colors.yellow,
    Colors.yellow[700]!,
    Colors.blue[300]!,
    Colors.blue,
    Colors.blue[700]!
  ];
  var topdown_matrix4 = Float64List.fromList(topdown);
  var right_matrix4 = Float64List.fromList(right);
  var left_matrix4 = Float64List.fromList(left);

  var temp = colornum * 3 - 2;

  paint.style = PaintingStyle.fill;

  if (colornum == 0) {
    return;
  }

  paint.color = mycolorlist[temp];

  canvas.save();
  canvas.transform(topdown_matrix4);
  canvas.drawRect(
      Offset(311.5 - z * 59 + x * 50, 33.5 - z * 58.4 + 49.5 * y) &
          Size(50, 50),
      paint);
  canvas.restore();

  paint.color = mycolorlist[temp + 1];
  canvas.save();
  canvas.transform(left_matrix4);
  canvas.drawRect(
      Offset(227 - y * 50.5 + x * 50, 72.5 - z * 50 + y * 42.5) & Size(50, 50),
      paint);
  canvas.restore();

  paint.color = mycolorlist[temp + 2];
  canvas.save();
  canvas.transform(right_matrix4);
  canvas.drawRect(
      Offset(277 - y * 50.5 + x * 50, 306 - z * 50 + x * 42.5) & Size(50, 50),
      paint);
  canvas.restore();

  paint.color = Colors.black;
  paint.strokeWidth = 1;
  paint.style = PaintingStyle.stroke;

  canvas.save();
  canvas.transform(topdown_matrix4);
  canvas.drawRect(
      Offset(311.5 - z * 59 + x * 50, 33.5 - z * 58.4 + 49.5 * y) &
          Size(50, 50),
      paint);
  canvas.restore();

  canvas.save();
  canvas.transform(left_matrix4);
  canvas.drawRect(
      Offset(227 - y * 50.5 + x * 50, 72.5 - z * 50 + y * 42.5) & Size(50, 50),
      paint);
  canvas.restore();

  canvas.save();
  canvas.transform(right_matrix4);
  canvas.drawRect(
      Offset(277 - y * 50.5 + x * 50, 306 - z * 50 + x * 42.5) & Size(50, 50),
      paint);
  canvas.restore();
}

Future<void> drawblockpng(String name, Blocks block, String directory) async {
  var recorder = new UI.PictureRecorder();
  final canvas = new Canvas(
      recorder, new Rect.fromPoints(new Offset(0, 0), new Offset(360, 340)));

  var paint = Paint();

  for (int i = 0; i < block.z; i++) {
    for (int j = 0; j < block.y; j++) {
      for (int k = 0; k < block.x; k++) {
        dimetric_cube(canvas, paint, k.toDouble(), j.toDouble(), i.toDouble(),
            block.body[k][j][i]);
      }
    }
  }

  final picture = recorder.endRecording();
  UI.Image img = await picture.toImage(360, 340);
  final abc = await img.toByteData(format: UI.ImageByteFormat.png);
  if (abc != null) // ?는 Nullable 이기 때문에 nonNullable로 바꿔줘야됨
  {
    await saveImage(name, abc, directory);
    debugPrint("저장됨");
  }
}
