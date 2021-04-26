import 'dart:convert';
import 'dart:math';
import 'package:collection/collection.dart';

var rng = Random(0);

/// 2d 종이접기
class PaperFold {
  /// 문제 유형
  ///
  /// - 0 종이를 접고 앞면 또는 뒷면이 맞는것 고르기
  /// - 1 종이를 접고 앞면 또는 뒷면이 아닌것 고르기
  int type = -1;

  /// 난이도
  ///
  /// - 0 가로, 세로, 대각선으로만 접기
  /// - 1 각도 제한없이 접기
  /// - 2 겹쳐진 일부만 접기
  int level = -1;
  var example;
  var suggestion;
  var answer;

  /// [0, range) 범위의 number개의 수. duplicate 가 true로 주어지면 중복을 허용하여 선택. 기본값은 false
  List rand(int number, int range, [bool duplicate = false]) {
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

  PaperFold(this.level, [this.type = -1]) {
    example = [];
    suggestion = [];
    answer = [];
    if (type == -1) {
      type = rand(1, 4)[0];
    }
    answer.add(rand(1, 4)[0]);
    for (var i = 0; i < 4; i++) {
      example.add(Paper());
      suggestion.add(Paper());
      answer.add(Paper());
    }
  }

  @override
  String toString() {
    var ty = '유형 : $type, 난이도 : $level\n';
    var ex = '예시 : \n';
    for (var i = 0; i < example.length; i++) {
      var exi = example[i];
      ex += '   $exi\n';
    }
    var su = '보기 : \n';
    for (var i = 0; i < suggestion.length; i++) {
      var sui = suggestion[i];
      su += '   $sui\n';
    }
    var an = '정답 : \n';
    for (var i = 0; i < answer.length; i++) {
      var ani = answer[i];
      an += '   $ani\n';
    }
    return ty + ex + su + an;
  }
}

class Paper {
  var layers;
  var layerCount;
  // var cartesian;

  Paper() {
    layerCount = 0;
    var count = rng.nextInt(5) + 1;
    layers = [];
    for (var i = 0; i < count; i++) {
      layerCount++;
      var layer = [];
      var n = rng.nextInt(5) + 1;
      for (var j = 0; j < n; j++) {
        var point = [];
        point.add(rng.nextInt(100));
        point.add(rng.nextInt(100));
        layer.add(point);
      }
      layers.add(layer);
    }
  }
  @override
  String toString() {
    var co = '레이어 수 : $layerCount\n';
    var la = '   레이어 : \n';
    for (var i = 0; i < layers.length; i++) {
      var exi = '     $i 번 레이어: ${layers[i]}\n';
      la += exi;
    }
    return co + la;
  }
}
