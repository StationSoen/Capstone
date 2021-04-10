import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  // SegmentControl Tab Collection
  Map<int, Widget> segmentControlTabs = {
    0: SegmentTabs(
      text: "쉬움",
    ),
    1: SegmentTabs(
      text: "보통",
    ),
    2: SegmentTabs(
      text: "어려움",
    ),
  };

  // index for SegmentControl - difficulty
  int difficulty = 0;

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
            "기록",
            style: TextStyle(fontSize: 18),
          ),
        ),
        child: SingleChildScrollView(
          // Padding for Navigation bar and Tabbar
          padding: EdgeInsets.only(top: 70, bottom: 50),
          child: Column(
            children: [
              CupertinoSegmentedControl(
                children: segmentControlTabs,
                groupValue: difficulty,
                padding: EdgeInsets.symmetric(vertical: 12),
                onValueChanged: (int value) {
                  setState(() {
                    difficulty = value;
                  });
                },
              ),
              RecordPageBody(
                difficulty: difficulty,
              ),
            ],
          ),
        ));
  }
}

class RecordPageBody extends StatelessWidget {
  int difficulty;

  RecordPageBody({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              width: double.infinity,
              child: Text("2D / 3D 전개도 유형 + 난이도 : $difficulty",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Colors.black)),
            ),
            RecordCard(
              icon: Icon(CupertinoIcons.square),
              name: "시도한 문제",
              value: "100",
            ),
            RecordCard(
              icon: Icon(CupertinoIcons.circle),
              name: "성공한 문제",
              value: "40",
            ),
            RecordCard(
              icon: Icon(CupertinoIcons.percent),
              name: "정답률",
              value: "40.0%",
            ),
            RecordCard(
              icon: Icon(CupertinoIcons.alarm),
              name: "시간 초과",
              value: "20",
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              width: double.infinity,
              child: Text("종이 접기 유형",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Colors.black)),
            ),
            RecordCard(
              icon: Icon(CupertinoIcons.square),
              name: "시도한 문제",
              value: "300",
            ),
            RecordCard(
              icon: Icon(CupertinoIcons.circle),
              name: "성공한 문제",
              value: "200",
            ),
            RecordCard(
              icon: Icon(CupertinoIcons.percent),
              name: "정답률",
              value: "66.7%",
            ),
            RecordCard(
              icon: Icon(CupertinoIcons.alarm),
              name: "시간 초과",
              value: "20",
            ),
          ],
        ),
      ),
    );
  }
}

class RecordCard extends StatelessWidget {
  final Icon icon;
  final String name;
  final String value;

  RecordCard({required this.icon, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      padding: EdgeInsets.all(12),
      height: 95,
      decoration: BoxDecoration(
        color: Color(0x184386F9),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            icon,
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.black))
          ]),
          Container(
              width: double.infinity,
              child: Text(name,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black)))
        ],
      ),
    );
  }
}

class SegmentTabs extends StatelessWidget {
  String text;
  SegmentTabs({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      child: Center(child: Text(text)),
    );
  }
}
