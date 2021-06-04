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


void dimetric_cube(Canvas canvas,Paint paint, double x, double y,double z, int colornum){

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
  canvas.drawRect(Offset(32.725-z*59+x*50, -23.5225-z*58.1+49.5*y) & Size(50, 50), paint);
  canvas.restore();

  paint.color = mycolorlist[temp + 1];
  canvas.save();
  canvas.transform(left_matrix4);
  canvas.drawRect(Offset(4.8-y*50.5+x*50, 23.25-z*50+y*42.5) & Size(50, 50), paint);
  canvas.restore();

  paint.color = mycolorlist[temp + 2];
  canvas.save();
  canvas.transform(right_matrix4);
  canvas.drawRect(Offset(54.8-y*50.5+x*50, 69.75-z*50+x*42.5) & Size(50, 50), paint);
  canvas.restore();



  paint.color=Colors.black;
  paint.strokeWidth=1;
  paint.style=PaintingStyle.stroke;


  canvas.save();
  canvas.transform(topdown_matrix4);
  canvas.drawRect(Offset(32.725-z*59+x*50, -23.5225-z*58.1+49.5*y) & Size(50, 50), paint);
  canvas.restore();

  canvas.save();
  canvas.transform(left_matrix4);
  canvas.drawRect(Offset(4.8-y*50.5+x*50, 23.25-z*50+y*42.5) & Size(50, 50), paint);
  canvas.restore();

  canvas.save();
  canvas.transform(right_matrix4);
  canvas.drawRect(Offset(54.8-y*50.5+x*50, 69.75-z*50+x*42.5) & Size(50, 50), paint);
  canvas.restore();



}



Future<void> drawblockpng(String name, Blocks block, String directory) async {
  var recorder = new UI.PictureRecorder();
  final canvas = new Canvas(
      recorder, new Rect.fromPoints(new Offset(0, 0), new Offset(360, 360)));

  var paint = Paint();

  int x=block.x;
  int y=block.y;
  int z=block.z;
  int recordx=10;
  int recordy=10;

  paint.style=PaintingStyle.stroke;
  if(x==2&&y==4&&z==3) {

    for(int i=0;i<z;i++){for(int j=0;j<y;j++){for(int k=0;k<x;k++) {dimetric_cube(canvas,paint, k.toDouble(), j.toDouble()-y+1,i.toDouble()-z-0.5, block.body[k][j][i]);}}}
    recordx=300;
    recordy=300;
  } else if (x==2&&y==3&&z==4) {
    for(int i=0;i<z;i++){for(int j=0;j<y;j++){for(int k=0;k<x;k++) {dimetric_cube(canvas,paint, k.toDouble(), j.toDouble()-y+1,i.toDouble()-z, block.body[k][j][i]);}}}
    recordx=250;
    recordy=330;
  } else if (x==4&&y==2&&z==3){
    for(int i=0;i<z;i++){for(int j=0;j<y;j++){for(int k=0;k<x;k++) {dimetric_cube(canvas,paint, k.toDouble(), j.toDouble()-y+1,i.toDouble()-z+0.3, block.body[k][j][i]);}}}
    recordx=300;
    recordy=300;
  }else if (x==4&&y==3&&z==2){
    for(int i=0;i<z;i++){for(int j=0;j<y;j++){for(int k=0;k<x;k++) {dimetric_cube(canvas,paint, k.toDouble(), j.toDouble()-y+1,i.toDouble()-z, block.body[k][j][i]);}}}
    recordx=340;
    recordy=270;
  } else if (x==3&&y==4&&z==2){
    for(int i=0;i<z;i++){for(int j=0;j<y;j++){for(int k=0;k<x;k++) {dimetric_cube(canvas,paint, k.toDouble(), j.toDouble()-y+1,i.toDouble()-z-0.3, block.body[k][j][i]);}}}
    recordx=340;
    recordy=270;
  }else if (x==3&&y==4&&z==2){
    for(int i=0;i<z;i++){for(int j=0;j<y;j++){for(int k=0;k<x;k++) {dimetric_cube(canvas,paint, k.toDouble(), j.toDouble()-y+1,i.toDouble()-z+0.4, block.body[k][j][i]);}}}
    recordx=250;
    recordy=330;
  }else if (x==3&&y==4&&z==3){
    for(int i=0;i<z;i++){for(int j=0;j<y;j++){for(int k=0;k<x;k++) {dimetric_cube(canvas,paint, k.toDouble(), j.toDouble()-y+1,i.toDouble()-z-0.5, block.body[k][j][i]);}}}
    recordx=350;
    recordy=330;
  } else if (x==4&&y==3&&z==3){
    for(int i=0;i<z;i++){for(int j=0;j<y;j++){for(int k=0;k<x;k++) {dimetric_cube(canvas,paint, k.toDouble(), j.toDouble()-y+1,i.toDouble()-z-0.5, block.body[k][j][i]);}}}
    recordx=350;
    recordy=330;
  } else if (x==3&&y==3&&z==4){
    for(int i=0;i<z;i++){for(int j=0;j<y;j++){for(int k=0;k<x;k++) {dimetric_cube(canvas,paint, k.toDouble(), j.toDouble()-y+1,i.toDouble()-z, block.body[k][j][i]);}}}
    recordx=300;
    recordy=350;
  }

  final picture = recorder.endRecording();
  UI.Image img = await picture.toImage(recordx, recordy);
  final abc = await img.toByteData(format: UI.ImageByteFormat.png);
  if (abc != null) // ?는 Nullable 이기 때문에 nonNullable로 바꿔줘야됨
  {
    await saveImage(name, abc, directory);
    debugPrint("저장됨");
  }
}


