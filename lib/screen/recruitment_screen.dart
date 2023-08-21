import 'package:flutter/material.dart';

import 'package:my_app/config/interface.dart';
import 'package:my_app/config/widgets/course_category.dart';
import 'package:my_app/config/widgets/recruitment_table.dart';

// 모집인원
class RecruitmentScreen extends StatefulWidget {
  RecruitmentScreen({Key? key}) : super(key: key);

  @override
  State<RecruitmentScreen> createState() => _RecruitmentScreenState();
}

class _RecruitmentScreenState extends State<RecruitmentScreen> {

  @override
  Widget build(BuildContext context) {
    double W = MediaQuery.of(context).size.width;
    return Stack(children: [
      // 타이틀
      Positioned(
          top: 5.0,
          left: 15.0,
          child: Text("모집 인원",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold))),
      // 카테고리 분류
      Positioned(
          top: 55.0,
          left: 20.0,
          right: 20.0,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AffiliationCategory(),  // 계열
                DepartmentCategory(dropdown_stream: dropdown_ctr.stream)    // 학과 & 전공
          ])),
      // 모집인원표
      Positioned(
        top: 100.0,
        child: Container(
          margin: EdgeInsets.all(20),
          width: W - 40,
          height: 440,
          child: RecruitmentTable(
            affil_stream: affil_ctr.stream,
            depart_stream: depart_ctr.stream,
          )
        )
      )
    ]);
  }
}