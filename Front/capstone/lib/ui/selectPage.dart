import 'package:capstone/visual/problem.dart';
import 'package:capstone/ui/problemPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
  int difficulty = 0;
  List<String> difficultyList = ["쉬움", "보통", "어려움"];

  double problemNumber = 1;

  double height = 80;
  double extendedHeight = 230;

  double time = 10;

  /// 난이도 선택하는 액션시트
  void difficultyActionsheet(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('쉬움'),
              onPressed: () {
                difficulty = 0;
                setState(() {});
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('보통'),
              onPressed: () {
                difficulty = 1;
                setState(() {});
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('어려움'),
              onPressed: () {
                difficulty = 2;
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          // Strange...
          heroTag: "recordPage",
          transitionBetweenRoutes: false,
          // Strange...
          middle: Text(
            "유형 및 난이도 선택",
            style: TextStyle(fontSize: 18),
          ),
        ),
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
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
                                    fontSize: 24, fontWeight: FontWeight.w600),
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
                AnimatedContainer(
                  height: 230,
                  duration: Duration(milliseconds: 250),
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 20),
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
                                "3D 전개도 유형",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                              CupertinoSwitch(value: true, onChanged: null),
                            ],
                          ),
                          Divider(),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "문제 수",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  Text(
                                    "${problemNumber.toInt()}개",
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.grey),
                                  )
                                ]),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 3),
                            child: CupertinoSlider(
                                value: problemNumber,
                                max: 10,
                                min: 1,
                                divisions: 9,
                                onChanged: (value) {
                                  setState(() {
                                    problemNumber = value;
                                  });
                                }),
                          ),
                          Divider(),
                          CupertinoButton(
                              padding: EdgeInsets.all(0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "난이도",
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.black),
                                    ),
                                    Text(
                                      difficultyList[difficulty],
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.grey),
                                    )
                                  ]),
                              onPressed: () {
                                difficultyActionsheet(context);
                              })
                        ],
                      )),
                ),
                CircleButton(
                  text: "문제 생성",
                  marginVertical: 5,
                  width: 345,
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () async {
                    // String tempDate = DateTime.now().toString();
                    //
                    DateFormat formatter = DateFormat('M_d_H_m_s');
                    String tempDate = formatter.format(DateTime.now());

                    String directory = await loaddirectory(tempDate);

                    debugPrint("problemNumber : $directory");
                    debugPrint("problemNumber : $tempDate");

                    List<dynamic> myProblemList = [
                      ...await makecubeproblem(
                          problemNumber.toInt(), difficulty, directory),
                    ];

                    Exam newExam = Exam(
                        dateCode: tempDate,
                        directory: directory,
                        remainTime: time.toInt(),
                        problemList: myProblemList);

                    // add newExan to (global) examList
                    examList.add(newExam);

                    // Navigator.pushNamed(context, '/problemPage');
                    Navigator.pushNamed(context, '/problemPage',
                        arguments: newExam);
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
        ));
  }
}
