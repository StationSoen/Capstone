import 'dart:math';

import 'package:plp/main.dart';
import 'package:plp/ui/problemPage.dart';
import 'package:plp/ui/selectPage.dart';
import 'package:plp/visual/blockproblem.dart';
import 'package:plp/visual/load.dart';
import 'package:plp/visual/paper_problem.dart';
import 'package:plp/visual/problem.dart';
import 'package:plp/visual/punchproblem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../exam.dart';
import 'component.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.only(top:10),
          decoration: gradientBackground,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // title part
              Container(
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      child: Image.asset(
                        'assets/logo/logo.png',
                      ),
                    ),
                    Container(
                      height: 40,
                      child: Image.asset('assets/logo/name.png'),
                    ),
                  ],
                ),
              ),

              // two main button
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 200,
                      width: 150,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.0),
                        color: const Color.fromRGBO(255, 255, 255, 75),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.17),
                            offset: Offset(0.0, 3.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            CupertinoIcons.cube_fill,
                            size: 46,
                            color: Color(0xFF4386F9),
                          ),
                          Text(
                            "무작위 문제",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4386F9)),
                          ),
                          SizedBox(
                            height: 30,
                            width: 90,
                            child: CupertinoButton(
                              borderRadius: BorderRadius.circular(18.0),
                              padding: EdgeInsets.symmetric(vertical: 0),
                              color: Color(0xFF4386F9),
                              onPressed: () {
                                // button tapped!
                                randomProblem(context);
                                // open selectPage();
                              },
                              child: Text(
                                "문제 풀기",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 200,
                      width: 150,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.0),
                        color: Color(0xFF4386F9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.17),
                            offset: Offset(0.0, 3.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            CupertinoIcons.bookmark_fill,
                            size: 46,
                            color: Colors.white,
                          ),
                          Text(
                            "오답 노트",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 30,
                            width: 90,
                            child: CupertinoButton(
                              borderRadius: BorderRadius.circular(18.0),
                              padding: EdgeInsets.symmetric(vertical: 0),
                              color: Colors.white,
                              onPressed: () {
                                // button tapped!
                                Navigator.pushNamed(
                                    context, '/previousComplete');
                              },
                              child: Text(
                                "다시 보기",
                                style: TextStyle(
                                    color: Color(0xFF4386F9),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 110,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleButton(
                      text: "이전 문제 계속",
                      onPressed: () {
                        Navigator.pushNamed(context, '/previousExamPage');
                      },
                    ),
                    CircleButton(
                      text: "새 문제 세트",
                      onPressed: () {
                        debugPrint("Button Tapped!");
                        Navigator.pushNamed(context, '/selectPage');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> randomProblem(BuildContext context) async {
    Random random = Random();

    var settingHive = Hive.box('setting');
    int problemType;
    int difficulty;

    List<dynamic> randomProblemSetting =
        settingHive.get('randomProlemSettingList', defaultValue: [
      [true, true, true],
      [true, true, true],
      [true, true, true],
    ]);
    double time =
        settingHive.get('randomProlemSettingTime', defaultValue: 300.0);

    while (true) {
      problemType = random.nextInt(3);
      difficulty = random.nextInt(3);

      if (randomProblemSetting[problemType][difficulty] == true) {
        break;
      }
    }

    DateFormat formatter = DateFormat('MM_dd_HH_mm_ss');
    String tempDate = formatter.format(DateTime.now());
    String directory = await loaddirectory(tempDate);
    List<Problem> problemList = [];
    if (problemType == 0) {
      problemList = await makecubeproblem(1, difficulty, directory);
    } else if (problemType == 1) {
      problemList = await makepaperproblem(1, difficulty, directory, 0);
    } else if (problemType == 2) {
      problemList = await makepunchproblem(1, difficulty, directory, 0);
    } else if (problemType == 3) {
      problemList = await makeblockproblem(1, difficulty, directory, 0);
    } else {
      problemList = await makecubeproblem(1, difficulty, directory);
    }
    Exam randomProblem = Exam(
        dateCode: tempDate,
        directory: directory,
        settingTime: time.toInt(),
        problemList: problemList,
        examType: 1);

    Navigator.pushNamed(context, '/problemPage', arguments: randomProblem);
  }
}
