import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:capstone/aboutPage.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var setting = Hive.box('setting');
  List<String> location = ["25%", "50%", "75%", "125%"];
  List<String> startSubtitle = ["60초", "5분", "10분"];
  int id = 0000;

  int result;
  int start;
  bool fingerPrint = false;

  void actionsheet(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          title: Container(
            padding: EdgeInsets.only(top: 10),
            child: const Text(
              '문제 크기 조정',
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
          ),
          message: const Text('문제 크기를 '),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('서서울관'),
              onPressed: () {
                result = 1;
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('동서울관'),
              onPressed: () {
                result = 2;
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('취소'),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
    );

    // if result invaild value : cancel before select anything.
    if (result == null) {
      result = 0;
    }

    debugPrint("result : " + result.toString());
    setting.put('location', result.toString());
  }

  void startActionsheet(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          title: Container(
            padding: EdgeInsets.only(top: 10),
            child: const Text(
              '시작회면 선택',
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
          ),
          message: const Text('앱 시작시 보여질 화면을 선택해주세요.'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('식단'),
              onPressed: () {
                start = 0;
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('출입'),
              onPressed: () {
                start = 1;
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('설정'),
              onPressed: () {
                start = 2;
                Navigator.pop(context);
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('취소'),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
    );

    // if start invaild value : cancel before select anything.
    if (start == null) {
      start = 0;
    }

    debugPrint("start : " + start.toString());
    setting.put('start', start.toString());
  }

  void launchEmailSubmission() async {
    final Uri params = Uri(
        scheme: 'mailto',
        path: 'optid77@gmail.com',
        queryParameters: {'subject': '버그리포트:', 'body': ''});
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  void _launchURL() async {
    const url =
        'https://github.com/kyw2271/cbhs_app/blob/main/Privacy%20Statement';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          // Strange...
          heroTag: "settingPage",
          transitionBetweenRoutes: false,
          // Strange...
          middle: Text(
            "설정",
            style: TextStyle(fontSize: 18),
          ),
        ),
        child: Container(
            padding: EdgeInsets.only(bottom: 50),
            color: Color(0xfff2f1f6),
            child: SettingsList(
              sections: [
                SettingsSection(
                  title: '개인 설정',
                  titleTextStyle: TextStyle(fontSize: 16),
                  tiles: [
                    SettingsTile(
                      title: '문제 배율 선택',
                      subtitle: location[int.parse(setting.get('location'))],
                      leading: Icon(CupertinoIcons.search),
                      onPressed: (BuildContext context) {
                        actionsheet(context);
                      },
                    ),
                    SettingsTile(
                      title: '랜덤 시드 선택',
                      subtitle: setting.get('id').toString(),
                      leading: Icon(CupertinoIcons.scribble),
                      onPressed: (BuildContext context) {
                        // do something here.
                      },
                    ),
                    SettingsTile(
                      title: '남은 시간 알람',
                      subtitle: startSubtitle[int.parse(setting.get('start'))],
                      leading: Icon(CupertinoIcons.alarm),
                      onPressed: (BuildContext context) {
                        startActionsheet(context);
                      },
                    ),
                  ],
                ),
                SettingsSection(
                    title: '앱 정보',
                    titleTextStyle: TextStyle(fontSize: 16),
                    tiles: [
                      SettingsTile(
                        title: '정보',
                        leading: Icon(CupertinoIcons.person),
                        onPressed: (BuildContext context) {
                          // showAboutDialog(
                          //     context: context,
                          //     applicationVersion: "1.0.0",
                          //     applicationName: "옴놈뇸",
                          //     applicationLegalese: "개발자",
                          //     applicationIcon: ImageIcon(
                          //         AssetImage("assets/images/logo.png")));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => AboutPage(
                                        appName: "오소리",
                                        appVersion: "0.1.0",
                                        developers:
                                            "Sunghyun(StationSoen@github)\nYoungwoo(kyw2271@github)",
                                        logoDesigner:
                                            "조하연(loosainfjn@naver.com)",
                                        githubLink:
                                            "github.com/kyw2271/cbhs_app",
                                      )));
                          debugPrint(setting.get('id').toString());
                        },
                      ),
                      SettingsTile(
                        title: '버그 리포트',
                        leading: Icon(CupertinoIcons.pencil_outline),
                        onPressed: (BuildContext context) {
                          launchEmailSubmission();
                        },
                      ),
                      SettingsTile(
                        title: '개인정보취급방침',
                        leading: Icon(CupertinoIcons.text_quote),
                        onPressed: (BuildContext context) {
                          _launchURL();
                        },
                      ),
                    ])
              ],
            )));
  }
}
