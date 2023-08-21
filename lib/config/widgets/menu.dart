import 'package:flutter/material.dart';

import 'package:my_app/config/data.dart';
import 'package:my_app/config/interface.dart';
import 'package:my_app/screen/guideline_screen.dart';
import 'package:my_app/screen/affil_explain_screen.dart';
import 'package:my_app/screen/map_screen.dart';

// 메뉴(Drawer)
class Menu extends StatelessWidget {
  Menu({Key? key}) : super(key: key);
  // 리스트의 아이템 Structure
  Widget _Item(String txt, BuildContext ctx) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 5),
      child: GestureDetector(
          onTap: () async {
            if (txt == "모집요강") {
              Navigator.push(ctx, MaterialPageRoute(
                  builder: (ctx) => GuidelineScreen(path: GuLi_pdf_path))
              );
            }
            else if (txt == "학과") {
              Navigator.push(ctx, MaterialPageRoute(
                  builder: (ctx) => AffilExplainScreen(path: AfEx_pdf_path)));
            }
            else if (txt == "지도") {
              pos = await getLocation();
              print("현재 위치 탐색 완료!");
              Navigator.push(ctx, MaterialPageRoute(
                  builder: (ctx) => MapScreen()));
            }
            Scaffold.of(ctx).closeDrawer();
          },
          child: Text(txt,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0)
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 175.0,
      backgroundColor: Colors.blue.shade800,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text("대충 이름",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                )),
            ),
            Container(
              width: 155, height: 2,
              margin: EdgeInsets.symmetric(vertical: 5),
              color: Colors.white,
            ),

            _Item("모집요강", context),  // 모집요강
            _Item("학과", context),     // 학과
            _Item("지도", context)      // 지도
          ],
        ),
      ),
    );
  }
}
