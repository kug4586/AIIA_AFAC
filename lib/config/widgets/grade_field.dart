import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:my_app/config/interface.dart';

// 성적 처리를 위한 데이터 형식
class GradeData {
  GradeData({
    required this.count, required this.score, required this.course});

  final int count;
  final String score, course;
}

// 모든 학기의 데이터
List<List<GradeData>> grade_table = [ [], [], [], [], [] ];

// 성적입력란
class GradeField extends StatefulWidget {
  GradeField({required this.W, required this.background, required this.semester});

  final double W;
  final Color background;
  final int semester;

  @override
  State<GradeField> createState() => _GradeFieldState();
}

// 성적입력란 (State)
class _GradeFieldState extends State<GradeField> {

  final List<String> semesters = [
    "1학년 1학기", "1학년 2학기", "2학년 1학기", "2학년 2학기", "3학년 1학기"];

  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    // structer
    return AnimatedContainer(
        width: widget.W,
        height: isTapped ? 400.0 : 120.0,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
        margin: EdgeInsets.symmetric(horizontal: 3.0, vertical: 5.0),
        duration: Duration(milliseconds: 400),
        curve: Curves.easeIn,
        child: SingleChildScrollView(
          child: Column(children: [
            // 확대 & 축소
            GestureDetector(
                onTap: () {
                  setState(() {
                    if (isTapped) isTapped = false;
                    else isTapped = true;
                  });
                },
                child: Container(
                    width: widget.W, height: 120.0,
                    decoration: BoxDecoration(
                        color: widget.background,
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Center(
                        child: Text(semesters[widget.semester],
                            style: TextStyle(
                                fontSize: 25.0, color: Colors.white))))),
            if (isTapped) // 탭이 눌린 상태일때만 보이는 창
              Column(children: [
                // 입력란
                Container(
                  width: widget.W - 20,
                  height: 40.0,
                  margin: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2.0),
                      boxShadow: [BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 3,
                            spreadRadius: 1)
                      ]),
                  child: _InputField(semester: widget.semester),
                ),
                // 데이터 표시창
                Container(
                  width: widget.W - 20,
                  height: 210.0,
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 3,
                            spreadRadius: 1)
                      ]),
                  child: _DataDisplay(
                      semester: widget.semester,
                      register_stream: register_ctr.stream,
                  ),
                )
              ])
          ]),
        ));
  }
}

// 입력란
class _InputField extends StatefulWidget {
  const _InputField({Key? key, required this.semester}) : super(key: key);

  final int semester;

  @override
  State<_InputField> createState() => _InputFieldState();
}

// 입력란 (State)
class _InputFieldState extends State<_InputField> {
  final TextEditingController _controller = TextEditingController();

  List<String> course_set = ["국어", "수학", "영어", "사회", "과학"];
  List<String> grade_set = [];

  int count = 0;
  String? course;
  String? grade;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      // 교과명
      Container(
        width: 80.0,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 1,
              spreadRadius: 1)
        ]),
        child: DropdownButton2(
            isExpanded: true,
            hint: Text("교과명",
                style: TextStyle(fontSize: 12.0)),
            items: course_set.map((e) =>
                DropdownMenuItem<String>(
                    value: e,
                    child: Text(e,
                        style: TextStyle(fontSize: 12.0)))).toList(),
            value: course,
            onChanged: (value) {
              setState(() {
                course = value as String;
                if (course == "사회" || course == "과학") {
                  grade_set = ["A", "B", "C"];
                }
                else {
                  grade_set = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
                }
              });
            },
            buttonStyleData: ButtonStyleData(
                width: 80, height: 50,
                decoration: BoxDecoration(color: Colors.white)
            ),
            dropdownStyleData: DropdownStyleData(maxHeight: 200),
            menuItemStyleData: MenuItemStyleData(height: 40),
            dropdownSearchData: DropdownSearchData(
                searchController: _controller,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 8),
                    child: TextFormField(
                        expands: true,
                        maxLines: null,
                        controller: _controller,
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),)))
                ),
                searchMatchFn: (item, searchValue) {
                  return (item.value.toString().contains(searchValue));
                }
            )
        )
      ),
      // 이수단위
      Container(
          width: 80.0,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 1,
                spreadRadius: 1)
          ]),
          child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              enabled: (course != null) ? true : false,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  count = int.parse(value);
                }
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '이수단위',
                  labelStyle: TextStyle(fontSize: 12.0)))),
      // 등급
      Container(
          width: 80.0,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 1,
                spreadRadius: 1)
          ]),
          child: DropdownButton2(
            hint: Text("등급",
              style: TextStyle(fontSize: 12)),
            items: grade_set.map((e) =>
                DropdownMenuItem(value: e,
                    child: Text(e, style: TextStyle(fontSize: 12)))
                ).toList(),
            value: grade,
            onChanged: (value) {
              setState(() => grade = value!);
            },
            buttonStyleData: const ButtonStyleData(
              height: 40, width: 140
            ),
            menuItemStyleData: const MenuItemStyleData(height: 40)
          )
      ),
      // 생성 버튼
      ElevatedButton(
          onPressed: () {
            // 만약 입력을 제대로 안 했다면
            if (course == null || count == 0 || grade == null) {
              // toast로 경고창 띄움
              Fluttertoast.showToast(msg: "모든 데이터를 입력하세요");
            }
            // 제대로 입력했다면
            else {
              // 데이터 추가
              grade_table[widget.semester]
                  .add(GradeData(count: count, score: grade!, course: course!));
              setState(() {
                // 입력란 초기화
                course = null;
                count = 0;
                grade = null;
                _controller.clear();
                grade_set = [];
                // 데이터 표시창 업데이트
                register_ctr.add(true);
              });
            }
          },
          child: Text("등록", style: TextStyle(fontSize: 14.0)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ))
    ]);
  }
}

// 데이터
class _DataDisplay extends StatefulWidget {

  final int semester;
  final Stream<bool> register_stream;

  const _DataDisplay({
    Key? key,
    required this.semester,
    required this.register_stream
  }) : super(key: key);

  @override
  State<_DataDisplay> createState() => _DataDisplayState();
}

// 데이터 (State)
class _DataDisplayState extends State<_DataDisplay> {

  void _update() => setState(() {});

  @override
  void initState() {
    super.initState();
    widget.register_stream.listen((event) => _update());
  }

  @override
  Widget build(BuildContext context) {
    List<GradeData> arr = grade_table[widget.semester];

    return ListView.builder(
      padding: EdgeInsets.all(5.0),
      itemCount: arr.length,
      itemBuilder: (context, index) {
        return Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(arr[index].course),
              Text(arr[index].count.toString()),
              Text(arr[index].score),
              GestureDetector(
                onTap: () {
                  setState(() {
                    arr.removeAt(index);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue),
                  child: Icon(Icons.remove,
                    color: Colors.white),
                )
              )
            ],
          ),
        );
      },
    );
  }
}
