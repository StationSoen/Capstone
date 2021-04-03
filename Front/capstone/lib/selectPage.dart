import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'component.dart';

class SelectPage extends StatefulWidget {
  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
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
                SelectionCard(),
                SelectionCard(),
                CircleButton(
                  text: "문제 생성",
                  marginVertical: 5,
                  width: 345,
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                CircleButton(
                  text: "생성 취소",
                  marginVertical: 5,
                  width: 345,
                  color: Colors.red,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ));
  }
}

class SelectionCard extends StatefulWidget {
  @override
  _SelectionCardState createState() => _SelectionCardState();
}

class _SelectionCardState extends State<SelectionCard> {
  bool cardOnOff = true;

  int difficulty = 0;
  List<String> difficultyList = ["쉬움", "보통", "어려움"];

  double time = 0.5;
  double problemNumber = 0;

  double height = 322;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: height,
      duration: Duration(milliseconds: 250),
      child: Container(
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
                    "2D 전개도 유형",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  CupertinoSwitch(
                      value: cardOnOff,
                      onChanged: (value) {
                        setState(() {
                          cardOnOff = value;
                          if (value) {
                            height = 322;
                          } else {
                            height = 80;
                          }
                        });
                      }),
                ],
              ),
              cardBody(cardOnOff)
            ],
          )),
    );
  }

  Widget cardBody(bool isOn) {
    if (isOn) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Divider(),
        Container(
          padding: EdgeInsets.only(top: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "시간 제한",
              style: TextStyle(fontSize: 17),
            ),
            Text(
              "${(time * 30).toInt()}초",
              style: TextStyle(fontSize: 17, color: Colors.grey),
            )
          ]),
        ),
        Container(
          padding: EdgeInsets.only(top: 3),
          child: CupertinoSlider(
              value: time,
              max: 10,
              min: 0,
              divisions: 4,
              onChanged: (value) {
                setState(() {
                  time = value;
                });
              }),
        ),
        Divider(),
        Container(
          padding: EdgeInsets.only(top: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "문제 수",
              style: TextStyle(fontSize: 17),
            ),
            Text(
              "${problemNumber.toInt()}개",
              style: TextStyle(fontSize: 17, color: Colors.grey),
            )
          ]),
        ),
        Container(
          padding: EdgeInsets.only(top: 3),
          child: CupertinoSlider(
              value: problemNumber,
              max: 10,
              min: 0,
              divisions: 10,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "난이도",
                    style: TextStyle(fontSize: 17, color: Colors.black),
                  ),
                  Text(
                    difficultyList[difficulty],
                    style: TextStyle(fontSize: 17, color: Colors.grey),
                  )
                ]),
            onPressed: () {
              difficultyActionsheet(context);
            })
      ]);
    } else {
      return Container();
    }
  }

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
}
