import 'package:capstone/problemPage.dart';
import 'package:capstone/scorePage.dart';
import 'package:capstone/selectPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'component.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 70, bottom: 70),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.1, -1),
          end: Alignment(0.1, 1),
          colors: [Color(0xFF0093E9), Color(0xFF80D0C7)],
          stops: [0.0, 1.0],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // title part
          Container(
            child: Column(
              children: [
                Text(
                  "점 선 면",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    // fontFamily: "Binggrae"
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  "By CAU Capstone Project",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                )
              ],
            ),
          ),

          // two main button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
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
                            debugPrint("SelectPage Open Button Tapped!");
                            // open selectPage();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SelectPage()));
                          },
                          child: Text(
                            "유형 선택",
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
                            debugPrint("Button Tapped!");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProblemPage()));
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
                    debugPrint("Button Tapped!");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ScorePage()));
                  },
                ),
                CircleButton(
                  text: "새 문제 세트",
                  onPressed: () {
                    debugPrint("Button Tapped!");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
