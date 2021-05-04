import 'dart:convert';

import 'package:capstone/ui/historyPage.dart';
import 'package:capstone/home.dart';
import 'package:capstone/ui/previousExamPage.dart';
import 'package:capstone/ui/problemDetalPage.dart';
import 'package:capstone/ui/problemPage.dart';
import 'package:capstone/ui/problemPaused.dart';
import 'package:capstone/ui/recordPage.dart';
import 'package:capstone/ui/scorePage.dart';
import 'package:capstone/ui/selectPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:ui' as UI;

import 'package:capstone/ui/settingPage.dart';

import 'logic/dev_cube.dart';
import 'ui/SplashScreen.dart';
import 'exam.dart';
import 'visual/load.dart';

/*

Next HiveField = 11

*/

// String dir = "";
List<Color?> colorlist = [
  Colors.red[700],
  Colors.orange,
  Colors.pink[200],
  Colors.yellow,
  Colors.black,
  Colors.lime,
  Colors.green[600],
  Colors.blue,
  Colors.cyan,
  Colors.indigo,
  Colors.brown,
  Colors.purple[600]
]; //색깔 리스트 길이:12
List<UI.Image> imglist = []; //숫자 이미지 리스트 길이:9    0~8 숫자, 9~20까지는 문양

/// 문제 풀이한 내역 및 관련 데이터 저장.
List<Exam> examList = [];

void main() async {
  // initialize Hive and opening Hive boxes..
  await Hive.initFlutter();
  Hive.registerAdapter(ExamAdapter());
  Hive.registerAdapter(CubeProblemAdapter());
  Hive.registerAdapter(DevCubeAdapter());

  await Hive.openBox('setting');
  var settingHive = Hive.box('setting');
  await Hive.openBox('examList');

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
    // await loaddirectory('test1');

    // await makecubeproblem(10, 1);

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
          return CupertinoApp(
            // cupertinoApp Settings ..
            debugShowCheckedModeBanner: false,
            theme: CupertinoThemeData(brightness: Brightness.light),
            localizationsDelegates: [
              DefaultMaterialLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              '/home': (BuildContext context) => new Home(),
              '/selectPage': (BuildContext context) => new SelectPage(),
              '/historyPage': (BuildContext context) => new HistoryPage(),

              // == PushNamed ==

              '/problemPage': (BuildContext context) => new ProblemPage(),
              '/scorePage': (BuildContext context) => new ScorePage(),
              '/recordPage': (BuildContext context) => new RecordPage(),
              '/previousExamPage': (BuildContext context) => PreviousExamPage(),
              '/problemDetailPage': (BuildContext context) =>
                  ProblemDetailPage(),
              // '/problemPaused': (BuildContext context) =>
              //     new ProblemPausedPage(),
            },

            home: MyHome(),
          );
        }

        // if future has error, show error page.
        if (snapshot.hasError) {
          return CupertinoApp(
            title: "Error Page",
            home: CupertinoPageScaffold(
              child: Center(child: Text("ERROR!")),
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
        border: Border(top: BorderSide(color: Colors.grey, width: 1.0)),
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
