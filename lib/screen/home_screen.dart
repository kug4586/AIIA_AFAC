import 'package:flutter/material.dart';
import 'package:my_app/config/data.dart';
import 'package:my_app/config/widgets/menu.dart';
import 'package:my_app/screen/info_screen.dart';
import 'package:my_app/screen/entrance.dart';

// 신입생 페이지
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// 신입생 페이지 (State)
class _HomeScreenState extends State<HomeScreen> {

  // 보여지는 페이지의 인덱스
  int _selected_index = 0;

  // NavigationBar로 보여줄 페이지들
  List _pages = [InfoScreen(), EntranceScreen()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getSize(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height
    );
    return Scaffold(
      backgroundColor: Colors.blue,

      // 메뉴창 (^)
      drawer: Menu(),

      // 불러오는 페이지
      body: Container(
        child: SafeArea(
          child: Center(
              child: _pages[_selected_index]),
        )
      ),

      // NavigationBar
      bottomNavigationBar: BottomNavigationBar(
        // 탭하면 State 업데이트
        onTap: (index) {
          setState(() { _selected_index = index; });
        },
        // 현재 활성화 된 아이템의 인덱스
        currentIndex: _selected_index,
        // NavigationBar에 보여줄 아이템들
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.collections), label: "정보"),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: "입학")
        ],
      ),
    );
  }
}

