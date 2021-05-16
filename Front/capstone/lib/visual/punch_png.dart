import '../main.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui'as UI;
import 'dart:math';
import 'package:path_drawing/path_drawing.dart';

Future<void> saveImage(
    String fileName, ByteData image, String directory) async {
  await File('${directory}/${fileName}.png')
      .writeAsBytes(image.buffer.asInt8List());
  // debugPrint('${directory}/${fileName}.png');

  // await File('${dir}/${fileName}.png').writeAsBytes(image.buffer.asInt8List());
}

void mypath(Canvas canvas,List a,paint){
  var path=Path();
  path.moveTo(a[0][0]*2,a[0][1]*2);
  for(int i=1;i<a.length;i++)
  {
    path.lineTo(a[i][0]*2,a[i][1]*2);
  }
  path.close();
  canvas.drawPath(path,paint);

}


void dashed_line_in(Canvas canvas,double startx, double starty,double endx,double endy, paint){
  var path=Path();
  path.moveTo(startx,starty);
  path.lineTo(endx, endy);
  canvas.drawPath(
    dashPath(
      path,
      dashArray: CircularIntervalList<double>(<double>[7.0, 7.0]),
    ),
    paint,
  );
}

void dashed_line_out(Canvas canvas,double startx, double starty,double endx,double endy, paint){
  var path=Path();
  path.moveTo(startx,starty);
  path.lineTo(endx, endy);
  canvas.drawPath(
    dashPath(
      path,
      dashArray: CircularIntervalList<double>(<double>[20.0, 7.0]),
    ),
    paint,
  );
}

void dashed_line_both(Canvas canvas,double startx, double starty,double endx,double endy, paint){

  var path=Path();
  path.moveTo(startx,starty);
  path.lineTo(endx, endy);

  canvas.drawPath(
    dashPath(
      path,
      dashArray: CircularIntervalList<double>(<double>[4.0, 4.0]),
    ),
    paint,
  );


  canvas.drawPath(
    dashPath(
      path,
      dashArray: CircularIntervalList<double>(<double>[20.0, 12.0]),
    ),
    paint,
  );

}

Future<void> drawpunchpng(String name, var pointList, var dotlineList, bool is_Last,String directory) async{

  var recorder = new UI.PictureRecorder();
  final canvas = new Canvas(
      recorder,
      new Rect.fromPoints(
          new Offset(0, 0), new Offset(100.0, 100.0)));

  var paint = Paint();


  List<List<double>> square=[[0,0],[0,100],[100,100],[100,0]];


  var radius=6.5; //점의 반지름


  final mycolor=Colors.deepOrange[50];
  var layers=pointList.layers;

  debugPrint('레이어 수는 ${pointList.layerCount}');


  for(int i=0;i<pointList.layerCount;i++)
  {

    paint.color=Colors.grey; //먼저 회색 외곽선을 그린 뒤
    paint.strokeWidth=1;
    mypath(canvas, square, paint);

    if(mycolor!=null) // 색 부분을 그리고
        {
      paint.color=mycolor;
    }
    paint.strokeWidth=1;
    paint.style=PaintingStyle.fill;
    mypath(canvas,layers[i], paint);
    //debugPrint('${pointList[1]}이라');

    paint.color=Colors.black; //검은선으로 감싼다
    paint.strokeWidth=1;
    paint.style=PaintingStyle.stroke;
    mypath(canvas,layers[i], paint);
  }

  if(is_Last){ //마지막 예시, 즉 점을 찍어야됨
    paint.style=PaintingStyle.fill;
    for(int i=0;i<dotlineList.length;i++)
    {

      canvas.drawCircle((Offset(dotlineList[i][0]*2,dotlineList[i][1]*2)), radius, paint);
    }


  }else{// 선을 찍어야됨
    for(int i=0;i<dotlineList.length;i++)
    {

      dashed_line_in(canvas, dotlineList[i][0][0]*2.toDouble(), dotlineList[i][0][1]*2.toDouble(),
          dotlineList[i][1][0]*2.toDouble(), dotlineList[i][1][1]*2.toDouble(), paint);
    }
  }

  // dashed_line_in(canvas, pointList[k][0][0], pointList[k][0][1],pointList[k][1][0],pointList[k][1][1], paint);

  final picture = recorder.endRecording();
  UI.Image img = await picture.toImage(200, 200);
  final abc =await img.toByteData(format:UI.ImageByteFormat.png);
  if(abc!=null) // ?는 Nullable 이기 때문에 nonNullable로 바꿔줘야됨
      {
    await saveImage(name,abc, directory);
    debugPrint("저장됨");
  }

}


Future<void> drawpunchsuggestionpng(String name, var dotList,String directory) async{

  var recorder = new UI.PictureRecorder();
  final canvas = new Canvas(
      recorder,
      new Rect.fromPoints(
          new Offset(0, 0), new Offset(200.0, 200.0)));

  var paint = Paint();


  List<List<double>> square=[[0,0],[0,200],[200,200],[200,0]];

  var radius=6.5; //점의 반지름



  final mycolor=Colors.deepOrange[50];

  paint.color=Colors.grey; //먼저 회색 외곽선을 그린 뒤
  paint.strokeWidth=1;
  mypath(canvas, square, paint);

  if(mycolor!=null) // 색 부분을 그리고
      {
    paint.color=mycolor;
  }

  paint.strokeWidth=1;
  paint.style=PaintingStyle.fill;
  mypath(canvas,square, paint);
  //debugPrint('${pointList[1]}이라');

  paint.color=Colors.black;
  paint.strokeWidth=1;
  paint.style=PaintingStyle.fill;


  for(int i=0;i<dotList.length;i++){
    canvas.drawCircle((Offset(dotList[i][0]*2,dotList[i][1]*2)), radius, paint);
  }






  final picture = recorder.endRecording();
  UI.Image img = await picture.toImage(200, 200);
  final abc =await img.toByteData(format:UI.ImageByteFormat.png);
  if(abc!=null) // ?는 Nullable 이기 때문에 nonNullable로 바꿔줘야됨
      {
    await saveImage(name,abc, directory);
    debugPrint("저장됨");
  }

}

Future<void> drawpunchnotepng(String name, var pointList, var lineList, var dotList,String directory) async{

  var recorder = new UI.PictureRecorder();
  final canvas = new Canvas(
      recorder,
      new Rect.fromPoints(
          new Offset(0, 0), new Offset(100.0, 100.0)));

  var paint = Paint();


  List<List<double>> square=[[0,0],[0,100],[100,100],[100,0]];


  var radius=6.5; //점의 반지름


  final mycolor=Colors.deepOrange[50];
  var layers=pointList.layers;

  debugPrint('레이어 수는 ${pointList.layerCount}');


  for(int i=0;i<pointList.layerCount;i++)
  {

    paint.color=Colors.grey; //먼저 회색 외곽선을 그린 뒤
    paint.strokeWidth=1;
    mypath(canvas, square, paint);

    if(mycolor!=null) // 색 부분을 그리고
        {
      paint.color=mycolor;
    }
    paint.strokeWidth=1;
    paint.style=PaintingStyle.fill;
    mypath(canvas,layers[i], paint);
    //debugPrint('${pointList[1]}이라');

    paint.color=Colors.black; //검은선으로 감싼다
    paint.strokeWidth=1;
    paint.style=PaintingStyle.stroke;
    mypath(canvas,layers[i], paint);
  }

  //마지막 예시, 즉 점을 찍어야됨
  for(int i=0;i<dotList.length;i++)
  {
    paint.style=PaintingStyle.fill;

    canvas.drawCircle((Offset(dotList[i][0]*2,dotList[i][1]*2)), radius, paint);
  }


  for(int i=0;i<lineList.length;i++)
  {

    dashed_line_in(canvas, lineList[i][0][0]*2.toDouble(), lineList[i][0][1]*2.toDouble(),
        lineList[i][1][0]*2.toDouble(), lineList[i][1][1]*2.toDouble(), paint);
  }






  // dashed_line_in(canvas, pointList[k][0][0], pointList[k][0][1],pointList[k][1][0],pointList[k][1][1], paint);







  final picture = recorder.endRecording();
  UI.Image img = await picture.toImage(200, 200);
  final abc =await img.toByteData(format:UI.ImageByteFormat.png);
  if(abc!=null) // ?는 Nullable 이기 때문에 nonNullable로 바꿔줘야됨
      {
    await saveImage(name,abc, directory);
    debugPrint("저장됨");
  }

}