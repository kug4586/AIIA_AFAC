import 'package:flutter/material.dart';
import 'package:my_app/config/data.dart';
import 'package:my_app/config/interface.dart';

// 모집인원표
class RecruitmentTable extends StatefulWidget {

  // Stream 수용자
  final Stream<String> affil_stream;
  final Stream<String> depart_stream;

  const RecruitmentTable({
    Key? key,
    required this.affil_stream,
    required this.depart_stream
  }) : super(key: key);

  @override
  State<RecruitmentTable> createState() => _RecruitmentTableState();
}

// 모집인원표 (State)
class _RecruitmentTableState extends State<RecruitmentTable> {

  // 표의 라벨
  Widget Label(String a, String b) {
    return GestureDetector(
      onTap: () => debugPrint(a),
      child: Text(b, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  // 계열 변화
  void _updateAffil(String affil) {
    setState(() => changeAffiliation(affil));
  }

  // 학과 변화
  void _updateDepart(String depart) {
    setState(() => changeDepartment(depart));
  }

  @override
  void initState() {
    super.initState();
    // stream 읽어들이기
    widget.affil_stream.listen((affil) => _updateAffil(affil));
    widget.depart_stream.listen((depart) => _updateDepart(depart));
  }

  @override
  Widget build(BuildContext context) {
    // 전체 틀 - 수직 스크롤
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Row(
        children: [

          // 학과 - 수직으로만
          DataTable(
              columnSpacing: 10,
              headingRowColor: MaterialStateProperty.all(Colors.blue[300]),
              dataRowColor: MaterialStateProperty.all(Colors.white),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
              ),
              columns: [
                DataColumn(label: Text("모집단위"))
              ],
              rows: arr.map((row) {
                String s;
                if (row[1] == "빅데이터경영학과") { s = "빅데이터\n경영학과"; }
                else if (row[1] == "미디어커뮤니케이션학과") { s = "미디어\n커뮤니케이션학과"; }
                else if (row[1] == "차세대반도체설계전공") { s = "차세대반도체\n설계전공"; }
                else if (row[1] == "스마트시티융합학과") { s = "스마트시티\n융합학과"; }
                else if (row[1] == "바이오의료기기학과") { s = "바이오\n의료기기학과"; }
                else if (row[1] == "반도체디스플레이학과") { s = "반도체\n디스플레이학과"; }
                else { s = row[1]; }
                return DataRow(cells: [DataCell(Label('hi', s))]);
              }).toList()),

          // 전형별 인원 - 수평 스크롤도 가능하게게
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.blue[100]),
                  dataRowColor: MaterialStateProperty.all(Colors.white),
                  columnSpacing: 20,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                  ),
                  columns: recruit_column
                      .map((e) {
                        String s;
                        if (e == "특성화고졸재직자") { s = "특성화\n고졸재직자"; }
                        else if (e == "조기취업형계약학과") { s = "조기취업형\n계약학과"; }
                        else { s = e; }
                        return DataColumn(label: Label('hello', s));
                      })
                      .toList(),
                  rows: arr.map((row) => DataRow(
                      cells: row.sublist(2).map((cell) => DataCell(
                          Center(child: Text((cell > 0) ? cell.toString() : ""))
                      )).toList()
                  )).toList()
              ),
            ),
          )

        ],
      ),
    );
  }
}
