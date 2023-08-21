import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:my_app/config/data.dart';
import 'package:my_app/config/interface.dart';
import 'package:my_app/screen/affil_explain_screen.dart';
import 'package:my_app/screen/guideline_screen.dart';
import 'package:my_app/screen/map_screen.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {

  // 스크롤을 막기 위한 컨트롤러
  ScrollController _controller = ScrollController(keepScrollOffset: false);

  // State 초기화
  @override
  void initState() {
    super.initState();
    // 권한 설정
    authorization();
    // 모집요강 pdf 불러오기
    fromAsset(GUIDELINE_PATH, 'guideline.pdf')
        .then((f) => GuLi_pdf_path = f.path);
    // 학과 브로슈어 pdf 불러오기
    fromAsset(AFFILEXPLAIN_PATH, 'affil_explain.pdf')
        .then((f) => AfEx_pdf_path = f.path);
  }

  // Assets에서 파일 불러오기
  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();
    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }
    return completer.future;
  }

  // 모집요강의 특정 페이지로 이동하는 버튼
  Widget GuidelinePageButton(BuildContext context, int page) {
    return ElevatedButton(
        onPressed: () {
          if (GuLi_pdf_path.isNotEmpty) {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                GuidelineScreen(path: GuLi_pdf_path, init_page: page)));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 3.0,
        ),
        child: Text(page2name[page]!,
            style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AppBar
        AppBar(
          title: Text("가천대"),
          centerTitle: true,
        ),

        // Body
        Container(
            width: SCREEN_WIDTH!,
            height: SCREEN_HEIGHT! - 139,
            decoration: Background,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 인트로?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("가천대를\n소개\n합니다",
                          style: TextStyle(fontSize: 36.0, color: Colors.white)),
                      Image.asset(MASCOT_PATH, width: 180, height: 300)
                    ],
                  ),

                  // 모집요강
                  Card(
                      color: Colors.white,
                      margin: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 3.0,
                      child: Column(
                        children: [
                          // pdf의 처음으로 이동하기
                          GestureDetector(
                            onTap: () {
                              if (GuLi_pdf_path.isNotEmpty) {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => GuidelineScreen(path: GuLi_pdf_path))
                                );
                              }
                            },
                            child: Container(
                              width: SCREEN_WIDTH! - 60, height: 40,
                              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                boxShadow: [BoxShadow(
                                  blurRadius: 1,
                                  spreadRadius: 0.1
                                )],
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Center(
                                child: Text("모집요강 보기",
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                )
                              ),
                            )
                          ),
                          // pdf의 특정 위치로 이동하기
                          Container(
                            width: SCREEN_WIDTH! - 40, height: 220,
                            padding: EdgeInsets.all(10),
                            child: GridView.count(
                                controller: _controller,
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 20,
                                childAspectRatio: 1/0.3,
                                children: page_list
                                    .map((e) => GuidelinePageButton(context, e))
                                    .toList()),
                          ),
                        ],
                      )
                  ),

                  // 학과 설명
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AffilExplainScreen(path: AfEx_pdf_path)));
                    },
                    child: Card(
                        color: Colors.white,
                        margin: EdgeInsets.all(20),
                        shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          width: SCREEN_WIDTH! - 40,
                          height: 180,
                          child: Center(
                            child: Text("학과", style: TextStyle(color: Colors.black)),
                          ),
                        )),
                  ),

                  // 지도
                  GestureDetector(
                    onTap: () async {
                      pos = await getLocation();
                      print("현재 위치 탐색 완료");
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => MapScreen()));
                    },
                    child: Card(
                        color: Colors.white,
                        margin: EdgeInsets.all(20),
                        shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          width: SCREEN_WIDTH! - 40,
                          height: 180,
                          child: Center(
                            child: Text("지도", style: TextStyle(color: Colors.black)),
                          ),
                        )),
                  )
                ],
              ),
            )
        )
      ],
    );
  }
}
