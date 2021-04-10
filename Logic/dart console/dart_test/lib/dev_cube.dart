import 'dart:math';
import 'package:collection/collection.dart';

class Cube {
  /// 문제 유형
  /// 0. 전개도를 보여주고 맞는 도형을 고르기
  /// 1. 전개도를 보여주고 틀린 도형을 고르기
  /// 2. 도형을 보여주고 맞는 전개도 고르기
  /// 3. 도형을 보여주고 틀린 전개도 고르기
  /// 4. 전개도 중 다른 하나 고르기
  static int type;

  var example;
  var suggestion;
  var answer;

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
    ['1', '0', '0', '0', '0', '1'],
    ['1', '0', '0', '0', '0', '2'],
    ['1', '0', '0', '0', '1', '0'],
    ['1', '0', '0', '0', '1', '1'],
    ['1', '0', '0', '0', '1', '2'],
    ['1', '0', '0', '0', '1', '0'],
    ['1', '1', '0', '0', '1', '1'],
  ];

  /// [0, range) 범위의 number개의 수. duplicate 가 true로 주어지면 중복을 허용하여 선택. 기본값은 false
  static List rand(int number, int range, [bool duplicate = false]) {
    var list = [];
    var rng = Random();
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
    var iso = isometrics[rand(1, 8)[0]];
    for (var i = 0; i < turn; i++) {
      var a = iso[0][0], b = iso[1][0];
      iso[0][0] = iso[0][1];
      iso[0][1] = iso[0][2];
      iso[0][2] = a;
      iso[1][0] = iso[1][1];
      iso[1][1] = iso[1][2];
      iso[1][2] = b;
    }
    for (var i = 0; i < 3; i++) {
      iso[0][i] = order[iso[0][i]];
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

  /// 등각투영도가 예시로, 여러 전개도가 보기로 주어진다.
  ///
  /// mode가 true이면 정답 하나를 찾기.
  /// mode가 false이면 다른 하나를 찾기.
  void isoQuestion(int count, bool mode) {
    var orders = []; //면의 순서
    var max = (mode) ? count : 2;
    for (var i = 0; i < max; i++) {
      var order;
      do {
        order = rand(6, 6);
      } while (isIn(orders, order));
      orders.add(order);
    }

    answer = []; // 정답 정보
    answer.add(rand(1, count)[0]); // 정답 번호
    answer.add(newDev(0, orders[(mode) ? answer[0] : 0]));

    example = newIso(answer[1][2]); // 예시

    suggestion = []; // 보기
    var list = rand(count, types.length); //전개도 유형 번호

    for (var i = 0; i < count; i++) {
      var n = list[i]; // 유형
      suggestion.add(newDev(n, orders[(mode) ? i : (answer[0] == i) ? 0 : 1]));
    }
  }

  /// 전개도가 예시로, 여러 등각투영도가 보기로 주어진다
  /// mode가 true이면 정답 하나를 찾기.
  /// mode가 false이면 다른 하나를 찾기.
  void devQuestion(int count, bool mode) {
    var orders = []; //면의 순서
    var max = (mode) ? count : 2;
    for (var i = 0; i < max; i++) {
      var order;
      do {
        order = rand(6, 6);
      } while (isIn(orders, order));
      orders.add(order);
    }

    answer = []; // 정답 정보
    answer.add(rand(1, count)[0]); // 정답 번호
    answer.add(newDev(0, orders[(mode) ? answer[0] : 0]));

    example = newDev(rand(1, types.length)[0], answer[1][2]); // 예시

    suggestion = []; // 보기
    var list = rand(count, types.length); //전개도 유형 번호

    for (var i = 0; i < count; i++) {
      var n = list[i]; // 유형
      suggestion.add(newIso(orders[(mode) ? i : (answer[0] == i) ? 0 : 1]));
    }
  }

  /// type:문제 유형
  /// example:예시 이미지
  /// suggestion:보기 데이터
  /// answer: 정답 데이터
  Cube() {
    type = rand(1, 5)[0];
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

  @override
  String toString() {
    var ty = '유형 : $type\n';
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
