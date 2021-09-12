import 'dart:convert';
import 'dart:math';
import 'package:plp/logic/paper_fold.dart';
import 'package:collection/collection.dart';

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
class HolePunch {
  /// 난이도
  ///
  /// - 0 앞으로만 접기
  /// - 1 앞뒤로 접기
  /// - 2 정해진 각도 이외로도 접기
  int level = -1;

  /// 타입은 하나뿐
  int type = 0;

  var example;
  var suggestion;
  var answer;

  var seed;
  late Random rng;

  static Random seedRng = Random();

  /// 리스트의 리스트 중복 검사
  static bool isIn(List list, var element) {
    for (var e in list) {
      if (ListEquality().equals(e, element)) return true;
    }
    return false;
  }

  // 선을 경계선 위의 두 점으로 변환
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
    var range = 5;
    var line, linetype;

    do {
      line = [];
      do {
        linetype = rng.nextInt((level == 2) ? 2 * range : range);
      } while (except.contains(linetype));

      var standard = (linetype / range).toInt();
      var modtype = linetype % range;

      if (standard == 0) {
        if (modtype == 0) {
          //세로
          line.add([1, 0, 50]);
        } else if (modtype == 1) {
          //가로
          line.add([0, 1, 50]);
        } else if (modtype == 2) {
          // 대각선 /
          line.add([1, 1, 100]);
        } else if (modtype == 3) {
          // 대각선 \
          line.add([1, -1, 0]);
        } else {
          if (rng.nextInt(2) > 0) {
            line.add([1, 0, 25]);
            line.add([1, 0, 75]);
          } else {
            line.add([0, 1, 25]);
            line.add([0, 1, 75]);
          }
        }
      } else {
        var x = rng.nextInt(51) + 25;
        var y = rng.nextInt(51) + 25;
        if (modtype == 0) {
          //세로
          line.add([1, 0, x]);
        } else if (modtype == 1) {
          //가로
          line.add([0, 1, y]);
        } else if (modtype == 2) {
          // 대각선 /
          line.add([1, 1, (rng.nextInt(2) > 0) ? 100 - x : 100 + x]);
        } else if (modtype == 3) {
          // 대각선 \
          line.add([1, -1, (rng.nextInt(2) > 0) ? y : -y]);
        } else {
          if (rng.nextInt(2) > 0) {
            line.add([1, 1, 50]);
            line.add([1, 1, 150]);
          } else {
            line.add([1, -1, 50]);
            line.add([1, -1, -50]);
          }
        }
      }
    } while (!crossedLines(paper, line));

    return [linetype, line];
  }

  bool crossedLines(Paper p, List lines) {
    for (var i = 0; i < lines.length; i++) {
      if (!p.isCrossed(lines[i])) return false;
    }
    return true;
  }

  /// * example[0] : [접힌 종이...]
  /// * example[1] : [[선, 방향]...]
  /// * suggsetion : [종이 ...]
  /// * answer     : [정답번호]
  HolePunch({required this.level, this.seed}) {
    seed ??= seedRng.nextInt(2147483647);
    rng = Random(seed);
    print('seed : $seed\n');

    /// 예시 데이터 생성
    var eMax = 4;

    var papers = [];
    var lines = [];
    var dots = [];

    // 종이 초기화
    papers.add(Paper());

    // 선 초기화
    var except = [], data, linetype, line;
    var select, linedata;
    var mathline = [];

    for (var i = 0; i < eMax - 1; i++) {
      data = setFoldLine(papers[i], except);
      linetype = data[0];
      line = data[1];
      except.add(linetype);
      mathline.add(line);

      select = [];
      linedata = [];
      // 선 정하기
      for (var i = 0; i < line.length; i++) {
        select.add(line[i][0] * 50 + line[i][1] * 50 - line[i][2] > 0);
        linedata.add(rangeEdge(line[i]));
      }
      lines.add(linedata);

      // 접기
      Paper nextPaper = papers[i].clone();
      for (var i = 0; i < line.length; i++) {
        nextPaper.foldPaper(line[i], select[i], true);
      }
      papers.add(nextPaper);
    }

    print('example : paper fold complete.');

    // 점 선택
    var dotOrigin = [];
    if (level == 0) {
      var shape = papers.last.layers.last;
      num x = 0, y = 0;
      var n = shape.length;
      for (var i = 0; i < n; i++) {
        x += shape[i][0];
        y += shape[i][1];
      }
      dotOrigin.add([x / n, y / n]);
    } else {
      var ln = papers.last.layers.length;
      // 맨 앞 레이어에서 고르기
      var dotRange = papers.last.layers[ln - 1].length;
      var dotEdge = rand(2, dotRange);
      for (var i = 0; i < dotEdge.length; i++) {
        dotOrigin.add(papers.last.layers.last[dotEdge[i]]);
      }
      var dot2nd = rng.nextInt(2);
      if (dot2nd > 0) {
        var dotMid = rand(2, dotRange);
        var dot0 = papers.last.layers.last[dotMid[0]];
        var dot1 = papers.last.layers.last[dotMid[1]];
        dotOrigin.add([(dot0[0] + dot1[0]) / 2, (dot0[1] + dot1[1]) / 2]);
      }
      if (dot2nd == 0) {
        var shape = papers.last.layers.last;
        num x = 0, y = 0;
        var n = shape.length;
        for (var i = 0; i < n; i++) {
          x += shape[i][0];
          y += shape[i][1];
        }
        dotOrigin.add([x / n, y / n]);
      }
      // 두번째 레이어에서 고르기
      dotRange = papers.last.layers[ln - 3].length;
      dotEdge = rand(2 + rng.nextInt(2), dotRange);
      if (rng.nextInt(3) == 0) {
        var dotMid = rand(2, dotRange);
        var dot0 = papers.last.layers[ln - 3][dotMid[0]];
        var dot1 = papers.last.layers[ln - 3][dotMid[1]];
        dotOrigin.add([(dot0[0] + dot1[0]) / 2, (dot0[1] + dot1[1]) / 2]);
      }
    }
    dots.add(dotOrigin);

    print('example : dot origin complete.');

    // 정답 생성
    var dotTemp, dotAnswer = json.decode(json.encode(dotOrigin));
    for (var i = eMax - 2; i >= 0; i--) {
      dotTemp = [];
      var dotLine = mathline[i];
      for (var j = 0; j < dotLine.length; j++) {
        var n = dotAnswer.length;
        for (var k = 0; k < n; k++) {
          var newDot = Paper.linearSymmerty(dotAnswer[k], dotLine[j]);
          if (!isIn(dotAnswer, newDot)) dotAnswer.add(newDot);
        }
      }
      for (var j = 0; j < dotAnswer.length; j++) {
        if (papers[i].isIn(dotAnswer[j])) dotTemp.add(dotAnswer[j]);
      }
      dotAnswer = dotTemp;
      dots.insert(0, json.decode(json.encode(dotAnswer)));
    }
    example = [papers, lines, dots];

    print('example : dot answer complete.');

    /// 정답과 보기
    var order = rand(eMax, eMax);
    order = [0, 1, 2, 3];
    answer = [order[0]];
    suggestion = List.filled(eMax, []);
    suggestion[order[0]] = dotAnswer;

    var dotWrong = rand(2, dotAnswer.length);
    var dot0, dot1;
    if (level < 1) {
      //오답 ( 결과에서 점을 옮겨 찍기 )
      var dotWrong1 = json.decode(json.encode(dotAnswer));
      dot0 = dotWrong1[0];
      dot1 = dotWrong1[1];
      dotWrong1.add([(dot0[0] + dot1[0]) / 2, (dot0[1] + dot1[1]) / 2]);
      dotWrong1.removeAt(rng.nextInt(dotWrong1.length - 1));
      suggestion[order[1]] = dotWrong1;
      print('example : suggestion 0 complete.');
      //오답 2
      var dotWrong2 = json.decode(json.encode(dotAnswer));
      var dotMid = rand(2, dotWrong2.length);
      dot0 = dotWrong2[dotMid[0]];
      dot1 = dotWrong2[dotMid[1]];
      dotWrong2.add([(dot0[0] + dot1[0]) / 2, (dot0[1] + dot1[1]) / 2]);
      dotWrong2.removeAt(rng.nextInt(dotWrong2.length - 1));
      suggestion[order[2]] = dotWrong2;
      print('example : suggestion 1 complete.');
      //오답 3
      var dotWrong3 = json.decode(json.encode(dotAnswer));
      dot0 = dotWrong3[1];
      dot1 = dotWrong3[2];
      dotWrong3.add([(dot0[0] + dot1[0]) / 2, (dot0[1] + dot1[1]) / 2]);
      dotWrong3.removeAt(rng.nextInt(dotWrong3.length - 1));
      suggestion[order[3]] = dotWrong3;
      print('example : suggestion 2 complete.');
    } else {
      // 오답 ( 일부분이 다른 초기 펀치홀로 생성하기 )
      var wrongTemp1, dotWrong1 = json.decode(json.encode(dotOrigin));
      dot0 = dotWrong1[0];
      dot1 = dotWrong1[1];
      dotWrong1.add([(dot0[0] + dot1[0]) / 2, (dot0[1] + dot1[1]) / 2]);
      dotWrong1.removeAt(rng.nextInt(dotWrong1.length - 1));
      for (var i = eMax - 2; i >= 0; i--) {
        wrongTemp1 = [];
        var dotLine = mathline[i];
        for (var j = 0; j < dotLine.length; j++) {
          var n = dotWrong1.length;
          for (var k = 0; k < n; k++) {
            var newDot = Paper.linearSymmerty(dotWrong1[k], dotLine[j]);
            if (!isIn(dotWrong1, newDot)) dotWrong1.add(newDot);
          }
        }
        for (var j = 0; j < dotWrong1.length; j++) {
          if (papers[i].isIn(dotWrong1[j])) wrongTemp1.add(dotWrong1[j]);
        }
        dotWrong1 = wrongTemp1;
      }
      suggestion[order[1]] = dotWrong1;

      // 오답 2
      var wrongTemp2, dotWrong2 = json.decode(json.encode(dotOrigin));
      dot0 = dotWrong2[1];
      dot1 = dotWrong2[2];
      dotWrong2.add([(dot0[0] + dot1[0]) / 2, (dot0[1] + dot1[1]) / 2]);
      dotWrong2.removeAt(rng.nextInt(dotWrong2.length - 1));
      for (var i = eMax - 2; i >= 0; i--) {
        wrongTemp2 = [];
        var dotLine = mathline[i];
        for (var j = 0; j < dotLine.length; j++) {
          var n = dotWrong2.length;
          for (var k = 0; k < n; k++) {
            var newDot = Paper.linearSymmerty(dotWrong2[k], dotLine[j]);
            if (!isIn(dotWrong2, newDot)) dotWrong2.add(newDot);
          }
        }
        for (var j = 0; j < dotWrong2.length; j++) {
          if (papers[i].isIn(dotWrong2[j])) wrongTemp2.add(dotWrong2[j]);
        }
        dotWrong2 = wrongTemp2;
      }
      suggestion[order[2]] = dotWrong2;

      // 오답 3
      var wrongTemp3, dotWrong3 = json.decode(json.encode(dotOrigin));
      dot0 = dotWrong3[0];
      dot1 = dotWrong3[2];
      dotWrong3.add([(dot0[0] + dot1[0]) / 2, (dot0[1] + dot1[1]) / 2]);
      dotWrong3.removeAt(rng.nextInt(dotWrong3.length - 1));
      for (var i = eMax - 2; i >= 0; i--) {
        wrongTemp3 = [];
        var dotLine = mathline[i];
        for (var j = 0; j < dotLine.length; j++) {
          var n = dotWrong3.length;
          for (var k = 0; k < n; k++) {
            var newDot = Paper.linearSymmerty(dotWrong3[k], dotLine[j]);
            if (!isIn(dotWrong3, newDot)) dotWrong3.add(newDot);
          }
        }
        for (var j = 0; j < dotWrong3.length; j++) {
          if (papers[i].isIn(dotWrong3[j])) wrongTemp3.add(dotWrong3[j]);
        }
        dotWrong3 = wrongTemp3;
      }
      suggestion[order[3]] = dotWrong3;
    }
  }

  @override
  String toString() {
    var ty = '난이도 : $level\n';
    var ex = '예시 : ';
    for (var i = 0; i < example[0].length - 1; i++) {
      ex += ' \n\n종이:\n ${example[0][i]} 선:';
      for (var j = 0; j < example[1][i].length; j++) {
        ex += '${example[1][i][j]}, ';
      }
    }
    ex += ' \n\n종이:\n ${example[0][3]} ';
    ex += ' 점찍기: ';
    for (var i = 0; i < example[2].length; i++) {
      ex += ' ${example[2][i]}, ';
    }
    var su = '\n보기 : ';
    for (var i = 0; i < suggestion.length; i++) {
      su += '\n $i번 : ';
      for (var j = 0; j < suggestion[i].length; j++) {
        su += '${suggestion[i][j]}, ';
      }
    }
    var an = '\n정답 : ${answer[0]}\n';
    return ty + ex + su + an;
  }
}
