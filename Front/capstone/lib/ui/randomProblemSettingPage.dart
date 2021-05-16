import 'package:capstone/ui/component.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class RandomProblemSettingPage extends StatefulWidget {
  @override
  _RandomProblemSettingPageState createState() =>
      _RandomProblemSettingPageState();
}

class _RandomProblemSettingPageState extends State<RandomProblemSettingPage> {
  late double time;

  /// first index = problem Type, second index = difficulty
  late List<dynamic> randomProblemSetting;

  var settingHive = Hive.box('setting');

  Widget typeOnOff(
      {required List<dynamic> list,
      required String title,
      required int problemType,
      required int difficulty}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 17,
                color: disableColors(
                    isDisable: list[problemType][difficulty],
                    inputColor: Colors.black)),
          ),
          CupertinoSwitch(
              value: list[problemType][difficulty],
              onChanged: (value) {
                setState(() {
                  list[problemType][difficulty] = value;
                });
              }),
        ],
      ),
    );
  }

  @override
  void initState() {
    this.randomProblemSetting =
        settingHive.get('randomProlemSettingList', defaultValue: [
      [true, true, true],
      [true, true, true],
      [true, true, true],
    ]);
    this.time = settingHive.get('randomProlemSettingTime', defaultValue: 360.0);
    print(this.time);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          // strange ..
          heroTag: 'randomProblemSettingPage',
          transitionBetweenRoutes: false,
          //strange ..

          middle: Text(
            "무작위 문제 옵션 설정",
            style: TextStyle(fontSize: 18),
          ),
          automaticallyImplyLeading: false,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 유형 ON-OFF 설정
                Container(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: basicBox,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "최대 시간 제한",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        Divider(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "제한 시간",
                                style: TextStyle(fontSize: 17),
                              ),
                              Text(
                                "${(time / 60).toInt().toString().padLeft(2, "0")}" +
                                    ":${(time % 60).toInt().toString().padLeft(2, "0")}",
                                style:
                                    TextStyle(fontSize: 17, color: Colors.grey),
                              )
                            ]),
                        Container(
                          padding: EdgeInsets.only(top: 3),
                          child: CupertinoSlider(
                              value: time,
                              max: 900,
                              min: 10,
                              divisions: 89,
                              onChanged: (value) {
                                setState(() {
                                  time = value;
                                });
                              }),
                        ),
                      ],
                    )),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: basicBox,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "포함할 유형 선택",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        Divider(),
                        typeOnOff(
                            title: "전개도 유형 - 쉬움",
                            problemType: 0,
                            difficulty: 0,
                            list: randomProblemSetting),
                        typeOnOff(
                            title: "전개도 유형 - 보통",
                            problemType: 0,
                            difficulty: 1,
                            list: randomProblemSetting),
                        typeOnOff(
                            title: "전개도 유형 - 어려움",
                            problemType: 0,
                            difficulty: 2,
                            list: randomProblemSetting),
                        typeOnOff(
                            title: "종이접기 유형 - 쉬움",
                            problemType: 1,
                            difficulty: 0,
                            list: randomProblemSetting),
                        typeOnOff(
                            title: "종이접기 유형 - 보통",
                            problemType: 1,
                            difficulty: 1,
                            list: randomProblemSetting),
                        typeOnOff(
                            title: "종이접기 유형 - 어려움",
                            problemType: 1,
                            difficulty: 2,
                            list: randomProblemSetting),
                      ],
                    )),
                CircleButton(
                  text: "설정 저장",
                  marginVertical: 5,
                  width: 345,
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    print(randomProblemSetting);
                    if (contains2DList(randomProblemSetting)) {
                      settingHive.put(
                          'randomProlemSettingList', randomProblemSetting);
                      settingHive.put('randomProlemSettingTime', time);
                      Navigator.pop(context);
                    } else {
                      print("no true in randomProblemSettingList");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool contains2DList(List<dynamic> list) {
    for (int i = 0; i < list.length; i++) {
      for (int j = 0; j < list[0].length; j++) {
        if (list[i][j] == true) {
          return true;
        }
      }
    }
    return false;
  }
}
