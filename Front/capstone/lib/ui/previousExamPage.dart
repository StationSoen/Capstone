import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:settings_ui/settings_ui.dart';

import '../exam.dart';

class PreviousExamPage extends StatefulWidget {
  @override
  _PreviousExamPageState createState() => _PreviousExamPageState();
}

class _PreviousExamPageState extends State<PreviousExamPage> {
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
          "풀이 내역",
          style: TextStyle(fontSize: 18),
        ),
      ),
      child: Container(
        color: Color(0xfff2f1f6),
        child: SettingsList(
          sections: [
            SettingsSection(
              title: '문제 풀이 내역',
              titleTextStyle: TextStyle(fontSize: 16),
              tiles: previousExamList(),
            ),
            // for padding.
            SettingsSection(
                title: '', titleTextStyle: TextStyle(fontSize: 16), tiles: []),
          ],
        ),
      ),
    );
  }
}

/// List
List<SettingsTile> previousExamList() {
  var examListHive = Hive.box('examList');
  List<Exam> list = examListHive.get('examList');

  List<SettingsTile> result = [];
  for (int i = 0; i < list.length; i++) {
    SettingsTile settingTile = new SettingsTile(
      title: list[i].dateCode,
      onPressed: (BuildContext context) {
        Navigator.pushNamed(context, '/problemDetailPage', arguments: list[i]);
      },
    );
    result.add(settingTile);
  }

  return result;
}
