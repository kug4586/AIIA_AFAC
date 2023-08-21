import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:my_app/config/data.dart';
import 'package:my_app/config/interface.dart';

// 계열 선택
class AffiliationCategory extends StatefulWidget {
  const AffiliationCategory({Key? key}) : super(key: key);

  @override
  State<AffiliationCategory> createState() => _AffiliationCategoryState();
}

// 계열 선택 (State)
class _AffiliationCategoryState extends State<AffiliationCategory> {

  // 선택지
  final List<String> affiliations = ["전체", "인문", "자연", "예체능"];

  @override
  Widget build(BuildContext context) {
    return DropdownButton2(
      hint: Text("계열",
          style: TextStyle(fontSize: 14.0)),
      items: affiliations.map((e) =>
          DropdownMenuItem<String>(
              value: e,
              child: Text(e,
                style: TextStyle(fontSize: 14.0)))).toList(),
      value: selected_affil,
      /*
      * 계열이 선택되면, 학과 dropdown은 초기화되고
      * 테이블은 계열에 맞게 리모델링 된다.
      */
      onChanged: (value) {
        setState(() {
          selected_affil = value!;
          affil_ctr.add(selected_affil!);
          dropdown_ctr.add(selected_affil!);
        });
      },
      buttonStyleData: ButtonStyleData(
        width: 100, height: 50,
        decoration: BoxDecoration(color: Colors.white)
      ),
      menuItemStyleData: MenuItemStyleData(height: 40),
    );
  }
}

// 학과 선택
class DepartmentCategory extends StatefulWidget {

  // stream 수용자
  final Stream<String> dropdown_stream;

  const DepartmentCategory({
    Key? key, required this.dropdown_stream
  }) : super(key: key);

  @override
  State<DepartmentCategory> createState() => _DepartmentCategoryState();
}

// 학과 선택 (State)
class _DepartmentCategoryState extends State<DepartmentCategory> {

  // 텍스트 입력란 컨트롤러
  final TextEditingController _text_ctr = TextEditingController();

  // dropdown의 아이템들
  List<String> _arr = recruit_data.map((row) => row[1] as String).toList();

  // 학과 Dropdown 업데이트하기
  void _updateDropdown(String affil) {
    setState(() {
      /* dropdown의 value는 초기화 */
      selected_depart = null;
      /* dropdown의 items는 계열에 맞게 리모델링 */
      if ((affil == "인문") || (affil == "자연") || (affil == "예체능")) {
        _arr = recruit_data
            .where((row) => row[0] == affil).toList()
            .map((row) => row[1] as String).toList();
      }
      else {
        _arr = recruit_data.map((row) => row[1] as String).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // stream 읽어들이기
    widget.dropdown_stream.listen((affil) => _updateDropdown(affil));
  }

  @override
  void dispose() {
    _text_ctr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton2(
      hint: Text("학과/전공",
          style: TextStyle(fontSize: 14.0)),
      items: _arr.map((e) => DropdownMenuItem<String>(
              value: e,
              child: Text(
                  e, style: TextStyle(fontSize: 14.0))
          )).toList(),
      value: selected_depart,
      onChanged: (value) {
        setState(() {
          selected_depart = value as String;
          depart_ctr.add(selected_depart!);
        });
      },
      buttonStyleData: ButtonStyleData(
          width: 200, height: 50,
          decoration: BoxDecoration(color: Colors.white)
      ),
      dropdownStyleData: DropdownStyleData(maxHeight: 200),
      menuItemStyleData: MenuItemStyleData(height: 40),
      dropdownSearchData: DropdownSearchData(
        searchController: _text_ctr,
        searchInnerWidgetHeight: 50,
        searchInnerWidget: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(
            horizontal: 4, vertical: 8),
          child: TextFormField(
            expands: true,
            maxLines: null,
            controller: _text_ctr,
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
    );
  }
}
