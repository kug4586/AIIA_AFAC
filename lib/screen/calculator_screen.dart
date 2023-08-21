import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:my_app/config/data.dart';
import 'package:my_app/config/widgets/grade_field.dart';

// 성적 산출
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

// 성적 산출 (State)
class _CalculatorScreenState extends State<CalculatorScreen> {
  double score = 0;

  @override
  Widget build(BuildContext context) {
    double W = MediaQuery.of(context).size.width;
    double H = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          // 타이틀
          Positioned(
              top: 5.0,
              left: 15.0,
              child: Text("교내 성적 반영",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold))),
          // 성적 입력란
          AnimatedPositioned(
            top: 45.0, left: 5.0, right: 5.0,
            duration: Duration(milliseconds: 400),
            curve: Curves.easeIn,
            child: AnimatedContainer(
                width: W, height: H - 170,
                padding: EdgeInsets.all(10.0),
                duration: Duration(milliseconds: 400),
                curve: Curves.easeIn,
                child: SingleChildScrollView(
                    child: Column(children: [
                  // 1학년 1학기
                  GradeField(W: W, background: Colors.orange, semester: 0),
                  // 1학년 2학기
                  GradeField(W: W, background: Colors.orange, semester: 1),
                  // 2학년 1학기
                  GradeField(W: W, background: Colors.orange, semester: 2),
                  // 2학년 2학기
                  GradeField(W: W, background: Colors.orange, semester: 3),
                  // 3학년 1학기
                  GradeField(W: W, background: Colors.orange, semester: 4),
                  // 점수 산출
                  Container(
                    width: W, height: 60,
                    margin: EdgeInsets.symmetric(horizontal: 3.0, vertical: 5.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // 만약 모든 학기가 입력되어있다면?
                            if (isFilled(grade_table)) {
                              setState(() => score = calculate(grade_table));
                            }
                            // 아니라면?
                            else {
                              Fluttertoast.showToast(msg: "모든 학기를 입력하세요");
                            }
                          },
                          child: Text("점수 산출"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                        ),
                        SizedBox(width: 10.0),
                        if (score != 0)
                          Text(
                              "당신의 점수는 \"${score.toStringAsFixed(2)}\" 입니다",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16.0)
                          )
                      ],
                    ),
                  )
                ]))),
          )
        ],
      ),
    );
  }
}

// 모든 학기를 입력했는지 확인하기
bool isFilled(List<List<GradeData>> arr) {
  bool ret = true;
  for (int i=0 ; i < 5 ; i++) {
    if (arr[i].isEmpty) {
      ret = false; break;
    }
  }
  return ret;
}

// 변수
class Score {
  Score(this.sum_major_score, this.sum_miner_score,
      this.sum_major_count, this.sum_miner_count, this.average);

  /*[교과합계, 비교과합계, 교과이수단위, 비교과이수단위, 평균]*/
  int sum_major_count, sum_miner_count;
  double sum_major_score, sum_miner_score;
  double average;
}

// 성적 산출하기
double calculate(List<List<GradeData>> arr) {
  List<Score> sum = [
    Score(0, 0, 0, 0, 0),
    Score(0, 0, 0, 0, 0),
    Score(0, 0, 0, 0, 0),
    Score(0, 0, 0, 0, 0),
    Score(0, 0, 0, 0, 0)];
  List<String> absolute = ["사회", "과학"];

  for (int i=0 ; i < 5 ; i++) {
    for (GradeData e in arr[i]) {
      bool without = true;
      for (String s in absolute) {
        if (e.course == s) {
          without = false; break;
        }
      }
      if (without) {
        sum[i].sum_major_score += changed1[e.score]! * e.count;
        sum[i].sum_major_count += e.count;
      }
      else {
        sum[i].sum_miner_score += changed2[e.score]! * e.count;
        sum[i].sum_miner_count += e.count;
      }
    }
    sum[i].average = sum[i].sum_major_score / sum[i].sum_major_count;
  }
  sum.sort((a,b) => (b.average - a.average).round());
  for (int i=0 ; i < 5 ; i++) {
    sum[i].average =
        (sum[i].sum_major_score + sum[i].sum_miner_score) / (sum[i].sum_major_count + sum[i].sum_miner_count);
  }

  return (sum[4].average*0.4 + sum[3].average*0.3 + sum[2].average*0.2 + sum[1].average*0.1);
}