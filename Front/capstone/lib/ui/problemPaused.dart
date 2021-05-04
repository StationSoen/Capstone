import 'package:capstone/ui/scorePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:settings_ui/settings_ui.dart';

import '../exam.dart';
import '../main.dart';

class ProblemPausedPage extends StatefulWidget {
  late int numberOfProblems;
  late Exam exam;

  ProblemPausedPage({required this.numberOfProblems, required this.exam});

  @override
  _ProblemPausedPageState createState() => _ProblemPausedPageState();
}

class _ProblemPausedPageState extends State<ProblemPausedPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          // Strange...
          heroTag: "pausedPage",
          transitionBetweenRoutes: false,
          // Strange...
          middle: Text(
            "일시정지",
            style: TextStyle(fontSize: 18),
          ),
        ),
        child: Container(
            color: Color(0xfff2f1f6),
            child: SettingsList(
              sections: [
                SettingsSection(
                    title: '문제 이동',
                    titleTextStyle: TextStyle(fontSize: 16),
                    tiles: builderForGoto(this.widget.numberOfProblems)),
                SettingsSection(
                  title: '제출',
                  titleTextStyle: TextStyle(fontSize: 16),
                  tiles: [
                    SettingsTile(
                      title: "제출하기",
                      onPressed: (BuildContext context) {
                        Navigator.pushNamed(context, '/scorePage',
                            arguments: this.widget.exam);

                        // examList 업데이트하고, Hive에 업데이트 해야 함.
                        debugPrint(
                            examList.indexOf(this.widget.exam).toString());
                      },
                    ),
                    SettingsTile(
                      title: "그만두기",
                      onPressed: (BuildContext context) {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      },
                    )
                  ],
                ),

                // for padding.
                SettingsSection(
                    title: '',
                    titleTextStyle: TextStyle(fontSize: 16),
                    tiles: []),
              ],
            )));
  }

  List<SettingsTile> builderForGoto(int number) {
    List<SettingsTile> result = [];

    for (int i = 0; i < number; i++) {
      SettingsTile settingsTile = new SettingsTile(
        title: '${i + 1}번 문제로 이동',
        onPressed: (BuildContext context) {
          Navigator.pop(context, i);
        },
      );
      result.add(settingsTile);
    }
    return result;
  }
}
