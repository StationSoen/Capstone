import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
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
              title: '그만둔 문제',
              titleTextStyle: TextStyle(fontSize: 16),
              tiles: previousExamList('pausedExamList'),
            ),
            SettingsSection(
              title: '제출한 문제',
              titleTextStyle: TextStyle(fontSize: 16),
              tiles: previousExamList('completeExamList'),
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
List<SettingsTile> previousExamList(String input) {
  var examListHive = Hive.box(input);
  List<Exam> list = examListHive.get(input);

  /// 05/04 20:07:18 생성된 시험지
  DateFormat formatter = DateFormat("MM/dd HH:mm:ss");
  List<SettingsTile> result = [];

  if (list.isEmpty) {
    // 아무 값도 없을 경우.
    result.add(new SettingsTile(title: "내역이 없습니다."));
    return result;
  } else {
    // 값이 있을 경우.
    for (int i = 0; i < list.length; i++) {
      SettingsTile settingTile = new SettingsTile(
        title: formatter
            .format(DateFormat('MM_dd_HH_mm_ss').parse(list[i].dateCode)),
        onPressed: (BuildContext context) {
          Navigator.pushNamed(context, '/problemDetailPage',
              arguments: list[i]);
        },
      );
      result.add(settingTile);
    }

    return result;
  }
}
