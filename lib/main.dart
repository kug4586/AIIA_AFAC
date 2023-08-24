import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import 'package:my_app/screen/home_screen.dart';

void main() async {
  // API 사용을 위한 초기화 작업
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: 'fqdlylx2gr');
  // 앱 실행
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // 디버깅 중인지 표시
      title: "Gachon Promotion",  // 앱 이름
      home: HomeScreen() // 앱 시작 화면
    );
  }
}
