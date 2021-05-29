import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:settings_ui/settings_ui.dart';

import '../exam.dart';
import '../main.dart';

class ProblemPausedPage extends StatefulWidget {
  late int numberOfProblems;

  // 남은 시간 원본인 Exam.
  late Exam exam;

  // 남은 시간 업데이트 한 Exam.
  late Exam updateTimeExam;

  ProblemPausedPage(
      {required this.numberOfProblems,
      required this.exam,
      required int elapsedTime}) {
    updateTimeExam = exam;
    updateTimeExam.elapsedTime = elapsedTime;
  }

  @override
  _ProblemPausedPageState createState() => _ProblemPausedPageState();
}

class _ProblemPausedPageState extends State<ProblemPausedPage> {
  var pausedExamListHive = Hive.box('pausedExamList');
  var completeExamListHive = Hive.box('completeExamList');

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
            "일시정지",
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: Container(
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
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/scorePage', ModalRoute.withName('/'),
                            arguments: this.widget.exam);

                        this.widget.exam.complete = true;

                        // pausedExamList에 값이 있다면, pausedExamList에서 제거해줘야 함.
                        pausedExamList.removeWhere((element) =>
                            element.dateCode == this.widget.exam.dateCode);
                        // completeExamList에 값 추가.
                        completeExamList.add(this.widget.exam);

                        // Hive에 업데이트.
                        completeExamListHive.put(
                            'completeExamList', completeExamList);
                        pausedExamListHive.put(
                            'pausedExamList', pausedExamList);

                        debugPrint("This Exam is in completeExamList index : " +
                            completeExamList
                                .indexOf(this.widget.exam)
                                .toString());
                      },
                    ),
                    SettingsTile(
                      title: "그만두기",
                      onPressed: (BuildContext context) {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                        if (this.widget.exam.examType != 2) {
                          if (pausedExamList.contains(this.widget.exam)) {
                            // pausedExamList에 값이 있다면 - 과거에 그만뒀던 것 다시 푸는 경우.
                            // pausedExamList에 remainTime 추가된 Exam 업데이트.
                            pausedExamList[
                                    pausedExamList.indexOf(this.widget.exam)] =
                                this.widget.updateTimeExam;
                          } else {
                            // pausedExamList에 값이 없다면 - 처음 그만두는 경우
                            // pausedExamList에 Add.
                            pausedExamList.add(this.widget.updateTimeExam);
                          }

                          // Hive 업데이트
                          pausedExamListHive.put(
                              'pausedExamList', pausedExamList);

                          // examList 업데이트하고, Hive에 업데이트 해야 함.
                          debugPrint("This Exam is in pausedExamList index : " +
                              pausedExamList
                                  .indexOf(this.widget.exam)
                                  .toString());
                        }
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
