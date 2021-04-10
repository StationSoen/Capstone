import 'dart:async';

import 'package:capstone/problemPaused.dart';
import 'package:cupertino_progress_bar/cupertino_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ProblemPage extends StatefulWidget {
  @override
  _ProblemPageState createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  SwiperController swiperController = new SwiperController();
  int indexPlus = 1;
  int second = 0;

  int maxSecond = 30;
  bool isPaused = true;

  _showCupertinoDialog() {
    showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              title: new Text("시간 초과"),
              content: new Text("설정된 시간이 완료되었습니다."),
              actions: <Widget>[
                CupertinoButton(
                  child: Text('제출'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (isPaused) {
          second++;
        }
      });
      if (second >= maxSecond) {
        timer.cancel();
        _showCupertinoDialog();
      }
      // debugPrint("$second");
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: CupertinoPageScaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          navigationBar: CupertinoNavigationBar(
            // Strange...
            heroTag: "problemPage",
            transitionBetweenRoutes: false,
            // Strange...

            middle: Stack(
              overflow: Overflow.visible,
              children: [
                Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$indexPlus / 20"),
                      Row(children: [
                        Text(
                            "${(second / 60).toInt().toString().padLeft(2, "0")}:${(second % 60).toInt().toString().padLeft(2, "0")} / ${(maxSecond / 60).toInt().toString().padLeft(2, "0")}:${(maxSecond % 60).toInt().toString().padLeft(2, "0")}"),
                        CupertinoButton(
                            padding: EdgeInsets.only(
                              left: 10,
                            ),
                            onPressed: () {
                              debugPrint("Tapped!");
                              isPaused = false;
                              _gotoIndex(context);
                            },
                            child: Icon(
                              CupertinoIcons.pause_fill,
                              color: Colors.red,
                            ))
                      ])
                    ],
                  ),
                )),
                Positioned(
                  left: -8,
                  right: -8,
                  bottom: 0,
                  child: CupertinoProgressBar(
                    value: second / maxSecond,
                    valueColor: Colors.red,
                    trackColor: null,
                  ),
                ),
              ],
            ),
            automaticallyImplyLeading: false,
          ),
          child: Container(
              padding: EdgeInsets.only(top: 70),
              width: double.infinity,
              child: Swiper(
                controller: swiperController,
                itemCount: 10,
                loop: false,
                itemBuilder: (BuildContext context, int index) {
                  return ProblemCard(
                    index: index,
                  );
                },
                onIndexChanged: (int i) {
                  setState(() {
                    indexPlus = i + 1;
                  });
                },
              ))),
    );
  }

  _gotoIndex(BuildContext buildContext) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ProblemPausedPage()));
    if (result != null) {
      swiperController.move(result);
    }
    isPaused = true;
  }
}

class ProblemCard extends StatefulWidget {
  double answerSize = 125;
  int index;

  ProblemCard({@required this.index});

  @override
  _ProblemCardState createState() => _ProblemCardState();
}

class _ProblemCardState extends State<ProblemCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      child: Column(
        children: [
          // Problem Question Section
          Container(
              width: double.infinity,
              child:
                  Text("#${this.widget.index + 1}\n전개도를 보고 해당하는 입체도형을 고르시오.")),
          Divider(),
          Container(
            height: 200,
            width: 200,
            color: Colors.red,
          ),
          Divider(),

          // Problem Answers Section
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    color: Colors.blue,
                    height: this.widget.answerSize,
                    width: this.widget.answerSize,
                  ),
                  Container(
                    color: Colors.blue,
                    height: this.widget.answerSize,
                    width: this.widget.answerSize,
                  )
                ],
              ),
              SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(
                  color: Colors.blue,
                  height: this.widget.answerSize,
                  width: this.widget.answerSize,
                ),
                Container(
                  color: Colors.blue,
                  height: this.widget.answerSize,
                  width: this.widget.answerSize,
                )
              ])
            ],
          )
        ],
      ),
    );
  }
}
