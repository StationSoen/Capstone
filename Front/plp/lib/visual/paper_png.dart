import '../main.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui'as UI;
import 'dart:math';
import 'package:path_drawing/path_drawing.dart';
import 'package:hive/hive.dart';

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

void mypathback(Canvas canvas,List a,paint){
  var path=Path();
  path.moveTo(200.0-a[0][0]*2,a[0][1]*2);
  for(int i=1;i<a.length;i++)
  {
    path.lineTo(200.0-a[i][0]*2,a[i][1]*2);
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

Future<void> drawpaperpng(String name, var pointList, var lineList,bool is_Last,bool is_suggestion ,String directory) async{

  var recorder = new UI.PictureRecorder();
  final canvas = new Canvas(
      recorder,
      new Rect.fromPoints(
          new Offset(0, 0), new Offset(200.0, 200.0)));

  var paint = Paint();


  List<List<double>> square=[[0,0],[0,200],[200,200],[200,0]];


  var settinghive=Hive.box('setting');

  Color mycolor=  Color(settinghive.get('color'));

  var layers=pointList.layers;
  var lines=lineList[0];
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
  if(!is_suggestion) {
    if (is_Last) {
      dashed_line_both(canvas, lines[0][0]*2.toDouble(), lines[0][1]*2.toDouble(),
          lines[1][0]*2.toDouble(), lines[1][1]*2.toDouble(), paint);
    } else {
      if (lineList[1]) {
        dashed_line_in(canvas, lines[0][0]*2.toDouble(), lines[0][1]*2.toDouble(),
            lines[1][0]*2.toDouble(), lines[1][1]*2.toDouble(), paint);
      } else {
        dashed_line_out(
            canvas, lines[0][0]*2.toDouble(), lines[0][1]*2.toDouble(),
            lines[1][0]*2.toDouble(), lines[1][1]*2.toDouble(), paint);
      }
    }
  }
  // dashed_line_in(canvas, pointList[k][0][0], pointList[k][0][1],pointList[k][1][0],pointList[k][1][1], paint);







  final picture = recorder.endRecording();
  UI.Image img = await picture.toImage(200, 200);
  final abc =await img.toByteData(format:UI.ImageByteFormat.png);
  if(abc!=null) // ?는 Nullable 이기 때문에 nonNullable로 바꿔줘야됨
      {
    await saveImage(name,abc, directory);
  //  debugPrint("저장됨");
  }

}

Future<void> drawpaperpngback(String name, var pointList, var lineList,var colorList,bool is_Last,bool is_suggestion ,String directory) async{

  var recorder = new UI.PictureRecorder();
  final canvas = new Canvas(
      recorder,
      new Rect.fromPoints(
          new Offset(0, 0), new Offset(200.0, 200.0)));

  var paint = Paint();


  List<List<double>> square=[[0,0],[0,200],[200,200],[200,0]];



  var settinghive=Hive.box('setting');

  Color mycolor1=  Color(settinghive.get('color'));
  final mycolor2=Colors.white;
  var layers=pointList.layers;
  var lines=lineList[0];
  debugPrint('레이어 수는 ${pointList.layerCount}');


  for(int i=pointList.layerCount-1;i>=0;i--)
  {

    paint.color=Colors.grey; //먼저 회색 외곽선을 그린 뒤
    paint.strokeWidth=1;
    mypath(canvas, square, paint);

    if(colorList[i]==0)
    {

      paint.color = mycolor2;
    }else {

      paint.color=mycolor1;
    }



    paint.strokeWidth=1;
    paint.style=PaintingStyle.fill;
    mypathback(canvas,layers[i], paint);
    //debugPrint('${pointList[1]}이라');

    paint.color=Colors.black; //검은선으로 감싼다
    paint.strokeWidth=1;
    paint.style=PaintingStyle.stroke;
    mypathback(canvas,layers[i], paint);
  }
  if(!is_suggestion) {
    if (is_Last) {
      dashed_line_both(canvas,200.0- lines[0][0]*2.toDouble(), lines[0][1]*2.toDouble(),
          200.0- lines[1][0]*2.toDouble(), lines[1][1]*2.toDouble(), paint);
    } else {
      if (!lineList[1]) {
        dashed_line_in(canvas, 200.0- lines[0][0]*2.toDouble(), lines[0][1]*2.toDouble(),
            200.0- lines[1][0]*2.toDouble(), lines[1][1]*2.toDouble(), paint);
      } else {
        dashed_line_out(
            canvas, 200.0- lines[0][0]*2.toDouble(), lines[0][1]*2.toDouble(),
            200.0- lines[1][0]*2.toDouble(), lines[1][1]*2.toDouble(), paint);
      }
    }
  }
  // dashed_line_in(canvas, pointList[k][0][0], pointList[k][0][1],pointList[k][1][0],pointList[k][1][1], paint);







  final picture = recorder.endRecording();
  UI.Image img = await picture.toImage(200, 200);
  final abc =await img.toByteData(format:UI.ImageByteFormat.png);
  if(abc!=null) // ?는 Nullable 이기 때문에 nonNullable로 바꿔줘야됨
      {
    await saveImage(name,abc, directory);
   // debugPrint("저장됨");
  }

}

Future<void> drawpaperpngfront(String name, var pointList, var lineList,var colorList,bool is_Last,bool is_suggestion ,String directory) async{

  var recorder = new UI.PictureRecorder();
  final canvas = new Canvas(
      recorder,
      new Rect.fromPoints(
          new Offset(0, 0), new Offset(200.0, 200.0)));

  var paint = Paint();


  List<List<double>> square=[[0,0],[0,200],[200,200],[200,0]];




  var settinghive=Hive.box('setting');

  Color mycolor1=  Color(settinghive.get('color'));
  final mycolor2=Colors.white;
  var layers=pointList.layers;
  var lines=lineList[0];
 // debugPrint('레이어 수는 ${pointList.layerCount}');


  for(int i=0;i<pointList.layerCount;i++)
  {

    paint.color=Colors.grey; //먼저 회색 외곽선을 그린 뒤
    paint.strokeWidth=1;
    mypath(canvas, square, paint);

    if(colorList[i]==0)
    {
      paint.color=mycolor1;
    }else {
      paint.color = mycolor2;
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
  if(!is_suggestion) {
    if (is_Last) {
      dashed_line_both(canvas, lines[0][0]*2.toDouble(), lines[0][1]*2.toDouble(),
          lines[1][0]*2.toDouble(), lines[1][1]*2.toDouble(), paint);
    } else {
      if (lineList[1]) {
        dashed_line_in(canvas, lines[0][0]*2.toDouble(), lines[0][1]*2.toDouble(),
            lines[1][0]*2.toDouble(), lines[1][1]*2.toDouble(), paint);
      } else {
        dashed_line_out(
            canvas, lines[0][0]*2.toDouble(), lines[0][1]*2.toDouble(),
            lines[1][0]*2.toDouble(), lines[1][1]*2.toDouble(), paint);
      }
    }
  }
  // dashed_line_in(canvas, pointList[k][0][0], pointList[k][0][1],pointList[k][1][0],pointList[k][1][1], paint);







  final picture = recorder.endRecording();
  UI.Image img = await picture.toImage(200, 200);
  final abc =await img.toByteData(format:UI.ImageByteFormat.png);
  if(abc!=null) // ?는 Nullable 이기 때문에 nonNullable로 바꿔줘야됨
      {
    await saveImage(name,abc, directory);
   // debugPrint("저장됨");
  }

}

