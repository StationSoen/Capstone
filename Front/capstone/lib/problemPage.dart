import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
          middle: Text(
            "남은 시간 : __",
            style: TextStyle(fontSize: 18),
          ),
        ),
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [],
            ),
          ),
        ));
  }
}

class ProblemCard extends StatefulWidget {
  @override
  _ProblemCardState createState() => _ProblemCardState();
}

class _ProblemCardState extends State<ProblemCard> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
