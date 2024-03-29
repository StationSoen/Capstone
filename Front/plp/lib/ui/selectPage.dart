import 'package:plp/visual/blockproblem.dart';
import 'package:plp/visual/paper_problem.dart';
import 'package:plp/visual/problem.dart';
import 'package:plp/ui/problemPage.dart';
import 'package:plp/visual/punchproblem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../exam.dart';
import 'component.dart';
import '../visual/load.dart';
import '../main.dart';

class SelectPage extends StatefulWidget {
  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  List<String> difficultyList = ["쉬움", "보통", "어려움"];

  // int difficulty = 0;
  // double problemNumber = 1;

  List<int> typeDifficulty = [0, 0, 0, 0];
  List<double> typeProblemNumber = [1, 1, 1, 1];
  List<bool> typeEnable = [true, true, true, true];

  double time = 10;

  /// HiveBox for global examListHive
  var examListHive = Hive.box('examList');

  /// 난이도 선택하는 액션시트
  void difficultyActionsheet(BuildContext contextm, int type) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('쉬움'),
              onPressed: () {
                typeDifficulty[type] = 0;
                setState(() {});
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('보통'),
              onPressed: () {
                typeDifficulty[type] = 1;
                setState(() {});
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('어려움'),
              onPressed: () {
                typeDifficulty[type] = 2;
                setState(() {});
                Navigator.pop(context);
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('취소'),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
    );
  }

  Widget typeSelector(String title, int type) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.17),
              offset: Offset(0.0, 3.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        width: 345,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: disableColors(
                          isDisable: typeEnable[type],
                          inputColor: Colors.black)),
                ),
                CupertinoSwitch(
                    value: typeEnable[type],
                    onChanged: (value) {
                      setState(() {
                        typeEnable[type] = value;
                      });
                    }),
              ],
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "문제 수",
                      style: TextStyle(
                          fontSize: 17,
                          color: disableColors(
                              isDisable: typeEnable[type],
                              inputColor: Colors.black)),
                    ),
                    Text(
                      "${typeProblemNumber[type].toInt()}개",
                      style: TextStyle(fontSize: 17, color: Colors.grey),
                    )
                  ]),
            ),
            Container(
              padding: EdgeInsets.only(top: 3),
              child: CupertinoSlider(
                  value: typeProblemNumber[type],
                  max: 10,
                  min: 1,
                  divisions: 9,
                  activeColor: disableColors(
                    isDisable: typeEnable[type],
                    inputColor: const Color(0xFF4386F9),
                  ),
                  onChanged: (value) {
                    if (typeEnable[type]) {
                      setState(() {
                        typeProblemNumber[type] = value;
                      });
                    }
                  }),
            ),
            Divider(),
            CupertinoButton(
                padding: EdgeInsets.all(0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "난이도",
                        style: TextStyle(
                            fontSize: 17,
                            color: disableColors(
                                isDisable: typeEnable[type],
                                inputColor: Colors.black)),
                      ),
                      Text(
                        difficultyList[typeDifficulty[type]],
                        style: TextStyle(fontSize: 17, color: Colors.grey),
                      )
                    ]),
                onPressed: () {
                  difficultyActionsheet(context, type);
                })
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: CupertinoNavigationBar(
          // Strange...
          heroTag: "recordPage",
          transitionBetweenRoutes: false,
          // Strange...
          middle: Text(
            "유형 및 난이도 선택",
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: basicBox,
                      width: 345,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "전체 설정",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Divider(),
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "시간 제한",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        Text(
                                          "${(time / 60).toInt().toString().padLeft(2, "0")}" +
                                              ":${(time % 60).toInt().toString().padLeft(2, "0")}",
                                          style: TextStyle(
                                              fontSize: 17, color: Colors.grey),
                                        )
                                      ]),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 3),
                                  child: CupertinoSlider(
                                      value: time,
                                      max: 900,
                                      min: 10,
                                      divisions: 89,
                                      onChanged: (value) {
                                        setState(() {
                                          time = value;
                                        });
                                      }),
                                ),
                              ],
                            )
                          ])),
                  typeSelector("3D 전개도 유형", 0),
                  typeSelector("종이접기 유형", 1),
                  typeSelector("펀칭 유형", 2),
                  typeSelector("블럭쌓기 유형", 3),
                  CircleButton(
                    text: "문제 생성",
                    marginVertical: 5,
                    width: 345,
                    color: const Color(0xFF4386F9),
                    textColor: Colors.white,
                    onPressed: () async {
                      
                      if (typeEnable[0] == true ||
                          typeEnable[1] == true ||
                          typeEnable[2] == true ||
                          typeEnable[3] == true) {
                        // String tempDate = DateTime.now().toString();
                        //
                        DateFormat formatter = DateFormat('MM_dd_HH_mm_ss');
                        String tempDate = formatter.format(DateTime.now());

                        String directory = await loaddirectory(tempDate);

                        debugPrint("problemNumber : $directory");
                        debugPrint("problemNumber : $tempDate");

                        List<Problem> myProblemList = [];

                        if (typeEnable[0] == true) {
                          myProblemList.addAll(await makecubeproblem(
                              typeProblemNumber[0].toInt(),
                              typeDifficulty[0],
                              directory));
                        } else {
                          typeProblemNumber[0] = 0;
                        }

                        if (typeEnable[1] == true) {
                          myProblemList.addAll(await makepaperproblem(
                              typeProblemNumber[1].toInt(),
                              typeDifficulty[1],
                              directory,
                              typeProblemNumber[0].toInt()));
                        } else {
                          typeProblemNumber[1] = 0;
                        }

                        if (typeEnable[2] == true) {
                          myProblemList.addAll(await makepunchproblem(
                              typeProblemNumber[2].toInt(),
                              typeDifficulty[2],
                              directory,
                              typeProblemNumber[0].toInt() +
                                  typeProblemNumber[1].toInt()));
                        } else {
                          typeProblemNumber[2] = 0;
                        }

                        if (typeEnable[3] == true) {
                          myProblemList.addAll(await makeblockproblem(
                              typeProblemNumber[3].toInt(),
                              typeDifficulty[3],
                              directory,
                              typeProblemNumber[0].toInt() +
                                  typeProblemNumber[1].toInt() +
                                  typeProblemNumber[2].toInt()));
                        }

                        Exam newExam = Exam(
                            dateCode: tempDate,
                            directory: directory,
                            settingTime: time.toInt(),
                            problemList: myProblemList,
                            examType: 0);

                        // Navigator.pushNamed(context, '/problemPage');
                        Navigator.pushNamed(context, '/problemPage',
                            arguments: newExam);
                      }
                    },
                  ),
                  CircleButton(
                    text: "생성 취소",
                    marginVertical: 5,
                    width: 345,
                    color: Colors.red,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
