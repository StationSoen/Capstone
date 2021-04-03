import 'dart:math';
import 'package:collection/collection.dart';

class Cube {
  /// 3D : 전개도 문제
  /// - 전개도를 보여주고 맞는 도형을 고르기
  /// - 전개도를 보여주고 틀린 도형을 고르기
  /// - 도형을 보여주고 맞는 전개도 고르기
  /// - 도형을 보여주고 틀린 전개도 고르기
  /// - 전개도 중 다른 하나 고르기

  /// 전개도 유형. 6개 면의 행-열 좌표 표기
  ///
  ///  전개도 디폴트(type 0)
  ///                ┌────┐
  ///                │ 00 │
  /// ┌────┬────┬────┼────┤
  /// │ 01 │ 02 │ 03 │ 04 │
  /// ├────┼────┴────┴────┘
  /// │ 05 │
  /// └────┘
  ///
  ///
  ///
  /*3D 전개도 유형을 나타낼 수 있는 데이터 구조 고안
  - 정육면체의 각면에 0~5의 번호를 지정했다고 가정
  - 11가지 전개도 유형에서 각 면의 위치를 행과 열이 표시된 문자열로 표기
  - 동시에 각 면의 회전 상태를 0~3의 번호로 표기 
  - 전개도를 생성할 때, 무작위로  유형을 선택
  */
  ///
  var type;
  var direction;
  List<dynamic> order = [1, 2, 3, 4, 5, 6];

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

  /// duplicate 가 true로 주어지면 중복을 허용하여 뽑음. 기본값은 false
  static List rand(int value, int range, [bool duplicate = false]) {
    var list = new List();
    var rng = new Random();
    for (var i = 0; i < value; i++) {
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

  /// mode가 true이면 정답 하나를 찾기.
  /// mode가 false이면 다른 하나를 찾기.
  static List devList(int count, bool mode) {
    var cubes = [];
    var list = rand(count, types.length);
    var orders = [];
    var max = (mode) ? count : 2;

    for (var i = 0; i < max; i++) {
      var order;
      do {
        order = rand(6, 6);
      } while (isIn(orders, order));
      orders.add(order);
    }

    cubes.add(Cube(list[0], orders[0]));
    for (var i = 1; i < count; i++) {
      cubes.add(Cube(list[i], orders[(mode) ? i : 1]));
    }

    return cubes;
  }

  Cube([int n = 0, this.order]) {
    this.type = types[n];
    this.direction = directions[n];
  }

  @override
  String toString() {
    return "($type,$direction,$order)\n";
  }
}
