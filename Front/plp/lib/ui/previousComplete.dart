import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:settings_ui/settings_ui.dart';

import '../exam.dart';
import 'component.dart';

class PreviousComplete extends StatefulWidget {
  @override
  _PreviousCompleteState createState() => _PreviousCompleteState();
}

class _PreviousCompleteState extends State<PreviousComplete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CupertinoNavigationBar(
        // Strange...
        heroTag: "pausedPage",
        transitionBetweenRoutes: false,
        // Strange...
        middle: Text(
          "오답 노트",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Container(
        color: Color(0xfff2f1f6),
        child: SettingsList(
          sections: [
            SettingsSection(
              title: '채점 내역',
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
  DateFormat formatter = DateFormat("MM/dd HH:mm:ss");
  List<SettingsTile> result = [];
  List<dynamic> list;

  if (examListHive.isNotEmpty) {
    list = examListHive.get(input);
  } else {
    result.add(new SettingsTile(title: "내역이 없습니다."));
    return result;
  }

  /// 05/04 20:07:18 생성된 시험지
  // 값이 있을 경우.
  for (int i = 0; i < list.length; i++) {
    SettingsTile settingTile = new SettingsTile(
      title: formatter
          .format(DateFormat('MM_dd_HH_mm_ss').parse(list[i].dateCode)),
      onPressed: (BuildContext context) {
        Navigator.pushNamed(context, '/scorePage', arguments: list[i]);
      },
    );
    result.add(settingTile);
  }

  return result;
}
