import 'dart:convert';

import 'package:plp/ui/historyPage.dart';
import 'package:plp/ui/home.dart';
import 'package:plp/ui/previousComplete.dart';
import 'package:plp/ui/previousExamPage.dart';
import 'package:plp/ui/scorePage.dart';
import 'package:plp/ui/problemDetalPage.dart';
import 'package:plp/ui/problemDetalPage.dart';
import 'package:plp/ui/problemPage.dart';
import 'package:plp/ui/recordPage.dart';
import 'package:plp/ui/selectPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plp/ui/settingPage.dart';
import 'dart:ui' as UI;

import 'ui/SplashScreen.dart';
import 'exam.dart';
import 'visual/load.dart';

/*
Next HiveField = 13
*/

// String dir = "";
List<Color?> colorlist = [
  Colors.red[700],
  Colors.orange,
  Colors.pink[200],
  Colors.yellow[200],
  Colors.black87,
  Colors.lime[700],
  Colors.green[600],
  Colors.blue,
  Colors.cyan,
  Colors.indigo,
  Colors.brown,
  Colors.purple[600]
]; //색깔 리스트 길이:12
List<UI.Image> imglist = []; //숫자 이미지 리스트 길이:9    0~8 숫자, 9~20까지는 문양

/// 그만두기를 통해서 중간에 멈춘 문제들 리스트
List<dynamic> pausedExamList = [];

/// 정상적으로 시험 끝낸 경우 문제들 리스트
List<dynamic> completeExamList = [];

void main() async {
  // initialize Hive and opening Hive boxes..
  await Hive.initFlutter();
  Hive.registerAdapter(ExamAdapter());
  Hive.registerAdapter(ProblemAdapter());

  await Hive.openBox('setting');
  var settingHive = Hive.box('setting');
  await Hive.openBox('examList');

  await Hive.openBox('pausedExamList');
  await Hive.openBox('completeExamList');

  await Hive.openBox('levelTest');
  var levelTestHive = Hive.box('levelTest');

  var pausedExamListHive = Hive.box('pausedExamList');
  var completeExamListHive = Hive.box('completeExamList');

  if (pausedExamListHive.get('pausedExamList') != null) {
    pausedExamList = pausedExamListHive.get('pausedExamList');
  }
  if (completeExamListHive.get('completeExamList') != null) {
    completeExamList = completeExamListHive.get('completeExamList');
  }

  if (levelTestHive.get('level') == null) {
    print("level hive Empty!, init");
    levelTestHive.put('level', [0, 0, 0, 0]);
  }

  if (settingHive.get('color') == null) {
    print("color is empty!, init");
    settingHive.put('color', '#FFFBE9E7');
  }

  debugPrint("Paused Exam List : " + completeExamList.toString());

  // initialize Hive Value ...
  List<String> hiveSetting = ['location', 'id', 'pw'];

  for (int i = 0; i < hiveSetting.length; i++) {
    if (settingHive.get(hiveSetting[i]) == null) {
      settingHive.put(hiveSetting[i], "0");
      settingHive.put('start', '0');
    }
  }

  // Hive initializing for TEST
  settingHive.put('start', '0');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future splashScreen() async {
    // wait for Splash Screen..

    await numimgload();
    await shapeimgload();

    print(imglist.length.toString());

    // do somthing here ..  ex) loading something
    // splash screen loading.
  }

  @override
  Widget build(BuildContext context) {
    // Future Builder for splash screen.
    return FutureBuilder(
      future: splashScreen(),
      builder: (context, snapshot) {
        // Once complete, show applications.
        if (snapshot.connectionState == ConnectionState.done) {
          debugPrint("Future loaded");
          // Load Thumbnail Articles
          return MaterialApp(
            // MaterialApp Settings ..
            debugShowCheckedModeBanner: false,

            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              '/home': (BuildContext context) => new Home(),
              '/selectPage': (BuildContext context) => new SelectPage(),
              '/historyPage': (BuildContext context) => new HistoryPage(),

              // == PushNamed ==

              '/problemPage': (BuildContext context) => new ProblemPage(),
              '/recordPage': (BuildContext context) => new RecordPage(),
              '/previousExamPage': (BuildContext context) => PreviousExamPage(),
              '/problemDetailPage': (BuildContext context) =>
                  ProblemDetailPage(),
              '/previousComplete': (BuildContext context) => PreviousComplete(),
              '/scorePage': (BuildContext context) => ScorePage(),
              // '/problemPaused': (BuildContext context) =>
              //     new ProblemPausedPage(),
            },

            home: MyHome(),
          );
        }

        // if future has error, show error page.
        if (snapshot.hasError) {
          return MaterialApp(
            title: "Error Page",
            home: Scaffold(
              body: Center(child: Text("ERROR!")),
            ),
          );
        }

        // else, view splash screen.
        return SplashScreen();
      },
    );
  }
}

class MyHome extends StatelessWidget {
  var setting = Hive.box('setting');

  // bottom tab bar list ..
  final List<BottomNavigationBarItem> bottomItems = [
    // BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: "홈"),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.house), label: "홈"),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.doc_chart), label: "기록"),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings), label: "설정"),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: int.parse(setting.get('start')),
        items: bottomItems,
        iconSize: 20,
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return Home();
          case 1:
            return RecordPage();
          default:
            return SettingPage();
        }
      },
    );
  }
}
