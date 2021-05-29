import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:settings_ui/settings_ui.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CupertinoNavigationBar(
          // Strange...
          heroTag: "historyPage",
          transitionBetweenRoutes: false,
          // Strange...
          middle: Text(
            "기록",
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: Container(
            color: Color(0xfff2f1f6),
            child: SettingsList(
              sections: [
                SettingsSection(
                  title: '제출 내역',
                  titleTextStyle: TextStyle(fontSize: 16),
                  tiles: builderForGoto(10),
                ),
                SettingsSection(
                  title: '미제출한 문제',
                  titleTextStyle: TextStyle(fontSize: 16),
                  tiles: builderForGoto(10),
                ),
                SettingsSection(
                  title: '제출',
                  titleTextStyle: TextStyle(fontSize: 16),
                  tiles: [
                    SettingsTile(
                      title: "취소",
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
