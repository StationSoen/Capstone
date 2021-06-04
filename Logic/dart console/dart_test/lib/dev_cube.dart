import 'dart:convert';
import 'dart:math';
import 'package:collection/collection.dart';

/// 3d 전개도
class DevCube {
  /// 문제 유형
  ///
  /// - 0 전개도를 보여주고 맞는 도형을 고르기
  /// - 1 전개도를 보여주고 틀린 도형을 고르기
  /// - 2 도형을 보여주고 맞는 전개도 고르기
  /// - 3 도형을 보여주고 틀린 전개도 고르기
  /// - 4 전개도 중 다른 하나 고르기
  int type = -1;

  /// 난이도
  ///
  /// - 0 단순 색깔
  /// - 1 구별하기 쉬운 숫자 및 도형
  /// - 2 구별이 어려운 문양
  int level = -1;

  late var example;
  late var suggestion;
  late var answer;
  late var seed;

  static var seedRng = Random();
  static var rng;

  /// 등각투영도와 방향 : 각각 0,1,2 순서대로 표기. 화살표방향이 0, 시계 반대방향 회전
  static var isometrics = [
    [
      [0, 1, 2],
      [3, 3, 2]
    ],
    [
      [0, 2, 3],
      [2, 3, 2]
    ],
    [
      [0, 3, 4],
      [1, 3, 2]
    ],
    [
      [0, 4, 1],
      [0, 3, 2]
    ],
    [
      [1, 5, 2],
      [0, 3, 1]
    ],
    [
      [2, 5, 3],
      [0, 0, 1]
    ],
    [
      [3, 5, 4],
      [0, 1, 1]
    ],
    [
      [4, 5, 1],
      [0, 2, 1]
    ]
  ];

  /// 전개도 유형별 좌표
  static var types = [
    ['03', '10', '11', '12', '13', '20'],
    ['03', '10', '11', '12', '13', '21'],
    ['03', '10', '11', '12', '13', '22'],
    ['03', '10', '11', '12', '13', '23'],
    ['02', '10', '11', '12', '13', '22'],
    ['02', '10', '11', '12', '13', '21'],
    ['02', '10', '11', '12', '03', '20'],
    ['02', '10', '11', '12', '03', '21'],
    ['02', '10', '11', '12', '03', '22'],
    ['02', '10', '11', '12', '03', '04'],
    ['02', '20', '11', '12', '03', '21'],
  ];

  /// 전개도 유형별 면 방향 0~3 : 시계 반대 방향 회전
  static var directions = [
    ['0', '0', '0', '0', '0', '0'],
    ['0', '0', '0', '0', '0', '1'],
    ['0', '0', '0', '0', '0', '2'],
    ['0', '0', '0', '0', '0', '3'],
    ['1', '0', '0', '0', '0', '2'],
    ['1', '0', '0', '0', '0', '1'],
    ['1', '0', '0', '0', '1', '0'],
    ['1', '0', '0', '0', '1', '1'],
    ['1', '0', '0', '0', '1', '2'],
    ['1', '0', '0', '0', '1', '0'],
    ['1', '1', '0', '0', '1', '1'],
  ];

  /// [0, range) 범위의 number개의 수. duplicate 가 true로 주어지면 중복을 허용하여 선택. 기본값은 false
  static List rand(int number, int range, [bool duplicate = false]) {
    var list = [];
    for (var i = 0; i < number; i++) {
      int n;
      do {
        n = rng.nextInt(range);
        if (duplicate) break;
      } while (list.contains(n));
      list.add(n);
    }
    return list;
  }

  /// 리스트의 리스트 중복 검사
  static bool isIn(List list, var element) {
    for (var e in list) {
      if (ListEquality().equals(e, element)) return true;
    }
    return false;
  }

  static bool checkEquality(var iso, var order) {
    var convIso = json.decode(json.encode(isometrics));
    for (var i = 0; i < convIso.length; i++) {
      for (var j = 0; j < convIso[i][0].length; j++) {
        convIso[i][0][j] = order[convIso[i][0][j]];
      }
    }
    for (var i = 0; i < convIso.length; i++) {
      if (convIso[i][0][0] == iso[0][0] &&
          convIso[i][0][1] == iso[0][1] &&
          convIso[i][0][2] == iso[0][2]) {
        return true;
      } else if (convIso[i][0][0] == iso[0][1] &&
          convIso[i][0][1] == iso[0][2] &&
          convIso[i][0][2] == iso[0][0]) {
        return true;
      } else if (convIso[i][0][0] == iso[0][2] &&
          convIso[i][0][1] == iso[0][0] &&
          convIso[i][0][2] == iso[0][1]) {
        return true;
      }
    }
    return false;
  }

  /// 등각투영도의 면과 방향 반환
  ///
  ///     ________
  ///    /       /\
  ///   /  0↑   /  \
  ///  /_______/ ↘ \
  ///  \       \ 2  /
  ///   \  1←   \  /
  ///    \_______\/
  ///
  /// 등각투영도와 방향 : 각각 0,1,2 순서대로 표기. 화살표방향이 0, 시계 반대방향 회전
  static List newIso(List order) {
    var turn = rand(1, 3)[0];
    var index = rand(1, 8)[0];
    var iso = [];
    iso.add(List.from(isometrics[index][0]));
    iso.add(List.from(isometrics[index][1]));
    for (var i = 0; i < turn; i++) {
      var a = iso[0][0], b = iso[1][0];
      iso[0][0] = iso[0][1];
      iso[0][1] = iso[0][2];
      iso[0][2] = a;
      iso[1][0] = iso[1][1];
      iso[1][1] = iso[1][2];
      iso[1][2] = b;
    }
    for (var j = 0; j < 3; j++) {
      iso[0][j] = order[iso[0][j]];
    }
    return iso;
  }

  /// 전개도, 회전 방향, 면의 순서를 반환
  ///
  /// 전개도 유형: 6개 면의 행-열 좌표 표기
  /// 전개도 디폴트(type 0)
  ///                ┌────┐
  ///                │ 00 │
  /// ┌────┬────┬────┼────┤
  /// │ 01 │ 02 │ 03 │ 04 │
  /// ├────┼────┴────┴────┘
  /// │ 05 │
  /// └────┘
  ///
  static List newDev(int number, List order) {
    var dev = [types[number], directions[number], order];
    return dev;
  }

  /// 난이도별로 index와 순서를 정해서 반환.
  ///
  /// - 쉬움(0)은 0~11 범위의 색상
  /// - 보통(1)은 0~8 범위의 숫자
  /// - 어려움(2)은 9~20 범위의 문양
  static List newOrder(int level, int number) {
    var range;
    switch (level) {
      case 0:
        range = 12;
        break;
      case 1:
        range = 8;
        break;
      case 2:
        range = 19;
        break;
    }
    var init = rand(6, range);
    if (level == 2) {
      for (var i = 0; i < 6; i++) {
        init[i] += 9;
      }
    }

    var orders = [];
    for (var i = 0; i < number; i++) {
      var order;
      do {
        order = rand(6, 6);
      } while (isIn(orders, order));
      orders.add(order);
    }

    var fitted = [];
    for (var i = 0; i < number; i++) {
      var fit = [];
      for (var j = 0; j < orders[i].length; j++) {
        fit.add(init[orders[i][j]]);
      }
      fitted.add(fit);
    }
    return fitted;
  }

  /// 등각투영도가 예시로, 여러 전개도가 보기로 주어진다.
  ///
  /// mode가 true이면 정답 하나를 찾기.
  /// mode가 false이면 다른 하나를 찾기.
  void isoQuestion(int count, bool mode) {
    var orders = (mode) ? newOrder(level, count) : newOrder(level, 2); //면의 순서

    answer = []; // 정답 정보
    answer.add(rand(1, count)[0]); // 정답 번호
    answer.add(newDev(0, orders[(mode) ? answer[0] : 0]));

    example = newIso(orders[(mode) ? answer[0] : 1]); // 예시

    suggestion = []; // 보기
    var list = rand(count, types.length); //전개도 유형 번호

    for (var i = 0; i < count; i++) {
      var n = list[i]; // 유형
      suggestion.add(newDev(
          n,
          orders[(mode)
              ? i
              : (answer[0] == i)
                  ? 0
                  : 1]));
    }
  }

  /// 전개도가 예시로, 여러 등각투영도가 보기로 주어진다
  /// mode가 true이면 정답 하나를 찾기.
  /// mode가 false이면 다른 하나를 찾기.
  void devQuestion(int count, bool mode) {
    var orders = (mode) ? newOrder(level, count) : newOrder(level, 2); //면의 순서

    answer = []; // 정답 정보
    answer.add(rand(1, count)[0]); // 정답 번호
    answer.add(newDev(0, orders[(mode) ? answer[0] : 0]));

    example =
        newDev(rand(1, types.length)[0], orders[(mode) ? answer[0] : 1]); // 예시

    suggestion = []; // 보기
    var list = rand(count, types.length); //전개도 유형 번호

    for (var i = 0; i < count; i++) {
      var n = list[i]; // 유형
      suggestion.add(newIso(orders[(mode)
          ? i
          : (answer[0] == i)
              ? 0
              : 1]));
    }
  }

  /// - type:문제 유형
  /// - example:예시 이미지
  /// - suggestion:보기 데이터
  /// - answer: 정답 데이터
  DevCube(this.level, [this.type = -1, this.seed]) {
    seed ??= seedRng.nextInt(2147483647);
    rng = Random(seed);

    if (type == -1) {
      type = rand(1, 4)[0];
    }
    if (level == 0) {
      var correct;
      switch (type) {
        case 0:
          do {
            correct = 0;
            devQuestion(4, true);
            for (var i = 0; i < 4; i++) {
              if (checkEquality(suggestion[i], example[2])) {
                correct++;
              }
            }
          } while (correct != 1);
          break;
        case 1:
          do {
            correct = 0;
            devQuestion(4, false);
            for (var i = 0; i < 4; i++) {
              if (checkEquality(suggestion[i], example[2])) {
                correct++;
              }
            }
          } while (correct != 3);
          break;
        case 2:
          do {
            correct = 0;
            isoQuestion(4, true);
            for (var i = 0; i < 4; i++) {
              if (checkEquality(example, suggestion[i][2])) {
                correct++;
              }
            }
          } while (correct != 1);
          break;
        case 3:
          do {
            correct = 0;
            isoQuestion(4, false);
            for (var i = 0; i < 4; i++) {
              if (checkEquality(example, suggestion[i][2])) {
                correct++;
              }
            }
          } while (correct != 3);
          break;
      }
    } else {
      switch (type) {
        case 0:
          devQuestion(4, true);
          break;
        case 1:
          devQuestion(4, false);
          break;
        case 2:
          isoQuestion(4, true);
          break;
        case 3:
          isoQuestion(4, false);
          break;
        case 4:
          isoQuestion(4, true);
          break;
      }
    }
  }

  @override
  String toString() {
    var ty = '유형 : $type, 난이도 : $level\n';
    var ex = '예시 : $example \n';
    var su = '보기 :  \n';
    for (var i = 0; i < suggestion.length; i++) {
      var sui = suggestion[i];
      su += '   $sui\n';
    }
    var an = '정답 : $answer \n';
    return ty + ex + su + an;
  }
}
