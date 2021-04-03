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
  double difficulty = 0;
  bool cardOnOff = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                  style: TextStyle(fontSize: 24),
                ),
                CupertinoSwitch(
                    value: cardOnOff,
                    onChanged: (value) {
                      setState(() {
                        cardOnOff = value;
                      });
                    })
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                "시간 제한",
                style: TextStyle(fontSize: 17),
              ),
              Text(
                "20분",
                style: TextStyle(fontSize: 17, color: Colors.grey),
              )
            ])
          ],
        ));
  }
}
