import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

/// 종이를 접는 조건
/// * 같은 방법을 연속해서 쓰지 않는다
/// * 범위 바깥으로 튀어나오게 접기 않는다
///
/// 위 조건을 만족하는 상황에서의 방법은 다음과같다
/// * 가로로 접기
/// * 세로로 접기
/// * 대각선 45도 /
/// * 대각선 135도 \
/// * 범위면의 인접한 두 면에서 점을 골라 삼각형으로 접기
///

/// 2d 종이접기
class PaperFold {
  /// 문제 유형
  ///
  /// - 0 종이를 접고 앞면 또는 뒷면이 맞는것 고르기
  /// - 1 종이를 접고 앞면 또는 뒷면이 아닌것 고르기
  var type;

  /// 난이도
  ///
  /// - 0 앞으로만 접기
  /// - 1 앞뒤로 접기
  /// - 2 정해진 각도 이외로도 접기
  int level;

  var example;
  var suggestion;
  var answer;

  var seed;
  late Random rng;

  static Random seedRng = Random();

  static List rangeEdge(List line) {
    var a = line[0];
    var b = line[1];
    var c = line[2];
    var points = [];

    if (a != 0 && c / a >= 0 && c / a <= 100) {
      points.add([c / a, 0.0]);
    }
    if (a != 0 && (c - b * 100.0) / a >= 0 && (c - b * 100.0) / a <= 100) {
      points.add([(c - b * 100.0) / a, 100.0]);
    }
    if (b != 0 && c / b > 0 && c / b < 100) {
      points.add([0.0, c / b]);
    }
    if (b != 0 && (c - a * 100.0) / b > 0 && (c - a * 100.0) / b < 100) {
      points.add([100.0, (c - a * 100.0) / b]);
    }
    return points;
  }

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

  /// 무작위 linetype과 line을 반환
  List setFoldLine(Paper paper, List except) {
    var range = (level == 2) ? 5 : 4;
    var line, linetype;

    do {
      do {
        linetype = rng.nextInt(3 * range);
        if (linetype >= 2 * range) linetype -= range;
        if (except.isNotEmpty && except.last < range && linetype < range) {
          linetype += range;
        }
      } while (except.contains(linetype) ||
          (except.isNotEmpty && except.last % range == linetype % range));

      var standard = (linetype / range).toInt();
      var modtype = linetype % range;

      if (standard == 0) {
        if (modtype == 0) {
          //세로
          line = [1, 0, 50];
        } else if (modtype == 1) {
          //가로
          line = [0, 1, 50];
        } else if (modtype == 2) {
          // 대각선 /
          line = [1, 1, 100];
        } else if (modtype == 3) {
          // 대각선 \
          line = [1, -1, 0];
        } else {
          var lv3 = rand(3, 2, true);
          var a = (lv3[0] > 0) ? 2 : 1;
          var b =
              (lv3[0] > 0) ? ((lv3[1] > 0) ? 1 : -1) : ((lv3[1] > 0) ? 2 : -2);
          var c = (lv3[1] > 0)
              ? ((lv3[2] > 0) ? 200 : 100)
              : ((lv3[2] > 0) ? 0 : ((lv3[0] > 0) ? 100 : -100));
          line = [a, b, c];
        }
      } else {
        var center = paper.center();
        var range = 50 - 10 * except.length;
        var x = rng.nextInt(61) + 20;
        if (modtype == 0) {
          //세로
          line = [1, 0, x];
        } else if (modtype == 1) {
          //가로
          line = [0, 1, x];
        } else if (modtype == 2) {
          // 대각선 /
          line = [1, 1, (rng.nextInt(2) > 0) ? 100 - x : 100 + x];
        } else if (modtype == 3) {
          // 대각선 \
          line = [1, -1, (rng.nextInt(2) > 0) ? x : -x];
        } else {
          var p1 = rng.nextInt(4);
          var p2 = rng.nextInt(2);
          var point1, point2;
          if (p1 == 0) point1 = [0, 0];
          if (p1 == 1) point1 = [0, 100];
          if (p1 == 2) point1 = [100, 100];
          if (p1 == 3) point1 = [100, 0];

          if (p2 == 0) point2 = [100 - point1[0], x];
          if (p2 == 1) point2 = [x, 100 - point1[1]];

          line = Paper.pointToLine(point1: point1, point2: point2);
        }
      }
    } while (!paper.isCrossed(line) ||
        !nearCenter(paper, line, 50 - 10 * except.length));

    return [linetype, line];
  }

  bool nearCenter(Paper p, List line, int value) {
    var center = p.center();
    var x = center[0], y = center[1];
    var a = line[0], b = line[1], c = line[2];
    var std = a * x + b * y - c;
    if (std > value || std < -value)
      return false;
    else
      return true;
  }

  /// * example[0] : [접힌 종이...]
  /// * example[1] : [[선, 방향]...]
  /// * suggsetion : [종이 ...]
  /// * answer     : [정답번호]
  PaperFold(this.level, [this.type, this.seed]) {
    seed ??= seedRng.nextInt(2147483647);
    rng = Random(seed);

    print('seed : $seed\n');

    type ??= rng.nextInt(2);
    if (level == 0) type = 0;

    var papers = [];
    var lines = [];

    // 종이 초기화
    papers.add(Paper());

    // 선 초기화
    var except = [], data, linetype, line;
    var select;

    data = setFoldLine(papers[0], except);
    linetype = data[0];
    line = data[1];
    except.add(linetype);

    select = rng.nextInt(2) > 0;
    var direction = (level == 0) ? true : rng.nextInt(2) > 0;
    if ((line[0] * 50 + line[1] * 50 - line[2]) * (select ? 1 : -1) < 0) {
      select = !select;
    }
    lines.add([rangeEdge(line), direction, line, select]);

    for (var i = 0; i < 3; i++) {
      // 접기
      Paper nextPaper = papers[i].clone();
      nextPaper.foldPaper(line, select, direction);
      papers.add(nextPaper);

      // 선 정하기
      data = setFoldLine(nextPaper, except);
      linetype = data[0];
      line = data[1];
      except.add(linetype);

      select = rng.nextInt(2) > 0;
      direction = (level == 0) ? true : rng.nextInt(2) > 0;
      if ((line[0] * 50 + line[1] * 50 - line[2]) * (select ? 1 : -1) < 0) {
        select = !select;
      }
      lines.add([rangeEdge(line), direction, line, select]);
    }
    // 예시 데이터
    example = [papers, lines];

    // 정답과 보기
    // var order = rand(4, 4);
    var order = [0, 1, 2, 3];
    answer = [order[0]];
    suggestion = List<Paper>.filled(4, Paper());
    if (type == 0) {
      // 정답(옳은 것)
      Paper p = papers[3].clone();
      p.foldPaper(line, select, direction);
      suggestion[order[0]] = p;

      //오답 1
      Paper s1 = papers[2].clone();
      s1.foldPaper(lines[2][2], lines[2][3], !lines[2][1]);
      s1.foldPaper(lines[3][2], lines[3][3], !lines[3][1]);
      suggestion[order[1]] = s1;

      //오답 2
      Paper s2 = p.clone();
      s2.layers.insert(0, s2.layers.removeLast());
      s2.layers.insert(0, s2.layers.removeLast());
      suggestion[order[2]] = s2;

      //오답 3
      Paper s3 = papers[0].clone();
      s3.foldPaper(lines[0][2], lines[0][3], !lines[0][1]);
      s3.foldPaper(lines[1][2], lines[1][3], !lines[1][1]);
      s3.foldPaper(lines[2][2], lines[2][3], !lines[2][1]);
      s3.foldPaper(lines[3][2], lines[3][3], !lines[3][1]);
      suggestion[order[3]] = s3;
    } else if (type == 1) {
      // 오답
      Paper p1 = papers[3].clone();
      p1.foldPaper(line, !select, direction);

      Paper p2 = papers[3].clone();
      p2.foldPaper(line, select, direction);

      except.removeLast();
      while (!p1.inRange() || !p2.inRange()) {
        data = setFoldLine(papers[3], except);
        line = data[1];

        p1 = papers[3].clone();
        p1.foldPaper(line, !select, direction);

        p2 = papers[3].clone();
        p2.foldPaper(line, select, direction);
      }

      lines[3][0] = rangeEdge(line);
      lines[3][2] = line;

      Paper p3 = papers[3].clone();
      p3.foldPaper(line, select, !direction);

      suggestion[order[1]] = p1;
      suggestion[order[2]] = p2;
      suggestion[order[3]] = p3;

      var wrong = rand(4, 2, true);
      var mp = wrong.map((e) => e > 0).toList();

      // 정답(틀린 것)
      Paper s = papers[0].clone();
      for (var i = 0; i < 4; i++) {
        s.foldPaper(lines[i][2], lines[i][3], mp[i] ^ !lines[i][1]);
      }
      suggestion[order[0]] = s;
    }
  }

  @override
  String toString() {
    var ty = '유형 : $type, 난이도 : $level\n';
    var ex = '예시 : \n';
    for (var i = 0; i < 4; i++) {
      ex +=
          ' 종이:\n ${example[0][i]} \n 선: ${example[1][i][0]}, 방향: ${example[1][i][1]}, 선택: ${example[1][i][3]}\n\n';
    }
    var su = '보기 : \n';
    for (var i = 0; i < 4; i++) {
      su += ' $i번 :\n ${suggestion[i]} \n\n';
    }
    var an = '정답 : ${answer[0]}\n';
    return ty + ex + su + an;
  }
}

/// 하나의 이미지로 보여지는 접힌 종이
class Paper {
  var layers = []; // 0이 맨 위 레이어
  var colors = [];
  var layerCount = 0;

  List center() {
    double x = 0, y = 0;
    double count = 0;
    for (var i = 0; i < layerCount; i++) {
      for (var j = 0; j < layers[i].length; j++) {
        x += layers[i][j][0];
        y += layers[i][j][1];
      }
      count += layers[i].length;
    }
    return [x / count, y / count];
  }

  bool inRange() {
    for (var i = 0; i < layerCount; i++) {
      var layer = layers[i];
      int p = layer.length;
      for (var j = 0; j < p; j++) {
        if (layer[j][0] < 0 || layer[j][0] > 100) return false;
        if (layer[j][1] < 0 || layer[j][1] > 100) return false;
      }
    }
    return true;
  }

  /// point가 접힌 종이 안에 있는지 체크
  bool isIn(List point) {
    var n = layerCount;
    var left, right;

    var px = point[0];
    var py = point[1];

    for (var i = 0; i < n; i++) {
      var layer = layers[i];
      int p = layer.length;
      left = 0;
      right = 0;
      for (var j = 0; j < p; j++) {
        var u = layer[(j - 1) % p][0];
        var v = layer[(j - 1) % p][1];

        var x = layer[j][0];
        var y = layer[j][1];

        if (px == u && py == v) return true;
        if (px == x && py == y) return true;

        if ((v <= y && py <= y && py >= v) || (v >= y && py >= y && py <= v)) {
          var newX;
          if (v == y) {
            newX = (x + u / 2);
          } else {
            var scale = (u - x) / (v - y);
            newX = scale * (py - y) + x;
          }
          if (newX > px) {
            right++;
          } else if (newX < px) {
            left++;
          } else {
            return true;
          }
        }
      }
      if ((left % 2 > 0) || (right % 2 > 0)) return true;
    }
    return false;
  }

  /// line이 접힌 종이를 지나는지 체크
  bool isCrossed(List line) {
    var n = layerCount;

    var a = line[0];
    var b = line[1];
    var c = line[2];

    for (var i = 0; i < n; i++) {
      var layer = layers[i];
      int p = layer.length;
      var left = false;
      var right = false;
      for (var j = 0; j < p; j++) {
        var x = layer[j][0];
        var y = layer[j][1];
        if (a * x + b * y < c) left = true;
        if (a * x + b * y > c) right = true;
      }
      if (left && right) return true;
    }
    return false;
  }

  /// * (x,y)형태의 좌표 Path의 집합인 layers를 ax + by = c 형태의 line으로 분할, 한쪽을 접는다.
  /// * select가 true면 왼쪽을, false면 오른쪽을 선택
  /// * direction이 true면 앞으로, false면 뒤로 접음
  void foldPaper(List line, bool select, bool direction) {
    var fold = [];
    var stay = [];
    var foldcolors = [];
    var staycolors = [];

    for (var i = 0; i < layerCount; i++) {
      var result = foldLayer(layers[i], line, select);
      var color = colors[i];
      if (result[0].length > 0) {
        if (select) {
          fold.insert(0, result[0]);
          foldcolors.insert(0, 1 - color);
        } else {
          stay.add(result[0]);
          staycolors.add(color);
        }
      }
      if (result[1].length > 0) {
        if (select) {
          stay.add(result[1]);
          staycolors.add(color);
        } else {
          fold.insert(0, result[1]);
          foldcolors.insert(0, 1 - color);
        }
      }
    }

    if (direction) {
      layers = stay + fold;
      colors = staycolors + foldcolors;
    } else {
      layers = fold + stay;
      colors = foldcolors + staycolors;
    }

    layerCount = layers.length;
  }

  /// line을 기준으로 point를 대칭한 점을 반환
  /// * point = (u,v)
  /// * line = (a,b,c) -> ax + by = c
  static List linearSymmerty(List point, List line) {
    var x, y;
    var a = line[0];
    var b = line[1];
    var c = line[2];
    var u = point[0];
    var v = point[1];

    x = (2 * a * c - a * a * u + b * b * u - 2 * a * b * v) / (a * a + b * b);
    y = (2 * b * c + a * a * v - b * b * v - 2 * a * b * u) / (a * a + b * b);
    return [x, y];
  }

  /// 두 line의 교점 반환
  static List intersection({required List line1, required List line2}) {
    var a = line1[0];
    var b = line1[1];
    var c = line1[2];

    var d = line2[0];
    var e = line2[1];
    var f = line2[2];

    var x = (b * f - c * e) / (b * d - a * e);
    var y = (c * d - a * f) / (b * d - a * e);

    return [x, y];
  }

  /// 두 point 를 지나는 선 반환
  static List pointToLine({required List point1, required List point2}) {
    var a = point2[1] - point1[1];
    var b = point1[0] - point2[0];
    var c = a * point1[0] + b * point1[1];

    return [a, b, c];
  }

  /// * (x,y)형태의 좌표 Path인 layer를 ax + by = c 형태의 line으로 분할, 한쪽을 대칭이동함.
  /// * direction이 true면 left를, false면 right를 반전
  static List foldLayer(List layer, List line, bool select) {
    List newLayer = json.decode(json.encode(layer));
    var n = newLayer.length;

    var a = line[0];
    var b = line[1];
    var c = line[2];

    var left = [];
    var right = [];

    // Path 분리
    for (var i = 0; i < n; i++) {
      var u = newLayer[(i - 1) % n][0];
      var v = newLayer[(i - 1) % n][1];
      var sign0 = a * u + b * v - c;

      var x = newLayer[i][0];
      var y = newLayer[i][1];
      var sign1 = a * x + b * y - c;

      if (sign0 * sign1 < 0) {
        var point = intersection(
            line1: pointToLine(point1: [u, v], point2: [x, y]), line2: line);
        left.add(point);
        right.add(point);
      }

      if (sign1 == 0) {
        left.add([x, y]);
        right.add([x, y]);
      } else if (sign1 > 0) {
        right.add([x, y]);
      } else if (sign1 < 0) {
        left.add([x, y]);
      }
    }

    // 한쪽 접기
    if (select) {
      for (var j = 0; j < left.length; j++) {
        left[j] = linearSymmerty(left[j], line);
      }
    } else {
      for (var j = 0; j < right.length; j++) {
        right[j] = linearSymmerty(right[j], line);
      }
    }

    if (left.length < 3) {
      left = [];
    }
    if (right.length < 3) {
      right = [];
    }
    return [left, right];
  }

  Paper clone() {
    var p = Paper();
    p.layerCount = layerCount;
    p.layers = json.decode(json.encode(layers));
    p.colors = json.decode(json.encode(colors));
    return p;
  }

  Paper() {
    layerCount = 1;
    layers.add([
      [0.0, 0.0],
      [100.0, 0.0],
      [100.0, 100.0],
      [0.0, 100.0]
    ]);
    colors.add(0);
  }

  @override
  String toString() {
    var co = '레이어 수 : $layerCount\n';
    var la = '   레이어 : \n';
    for (var i = 0; i < layers.length; i++) {
      var exi = '     $i 번 레이어: ${layers[i]}\n';
      la += exi;
    }
    return co + la + colors.toString();
  }
}
