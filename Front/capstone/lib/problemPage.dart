import 'package:cupertino_progress_bar/cupertino_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'component.dart';

class ProblemPage extends StatefulWidget {
  @override
  _ProblemPageState createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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
                    Text("10 / 20"),
                    Row(children: [
                      Text("11:59 / 15:00"),
                      CupertinoButton(
                          padding: EdgeInsets.only(
                            left: 10,
                          ),
                          onPressed: () {
                            debugPrint("Tapped!");
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
                  value: 0.5,
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
              itemCount: 10,
              loop: false,
              itemBuilder: (BuildContext context, int index) {
                return ProblemCard(
                  index: index,
                );
              },
            )));
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
