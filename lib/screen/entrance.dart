import 'package:flutter/material.dart';

import 'package:my_app/config/data.dart';
import 'package:my_app/screen/recruitment_screen.dart';
import 'package:my_app/screen/calculator_screen.dart';

class EntranceScreen extends StatefulWidget {
  const EntranceScreen({Key? key}) : super(key: key);

  @override
  State<EntranceScreen> createState() => _EntranceScreenState();
}

class _EntranceScreenState extends State<EntranceScreen>
    with SingleTickerProviderStateMixin {
  int _page = 0;
  late PageController _pController;
  late TabController _tController;

  @override
  void initState() {
    super.initState();
    _pController = PageController();
    _tController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _pController.dispose();
    _tController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: TabBar(
          controller: _tController,
          labelColor: Colors.orangeAccent,
          onTap: (value) {
            _page = value;
            _pController.animateToPage(_page,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
            },
          tabs: [
            Tab(icon: Icon(Icons.table_view)),
            Tab(icon: Icon(Icons.calculate))
          ]
        ),
      ),
      Expanded(
        child: Container(
          decoration: Background,
          child: PageView(
            controller: _pController,
            scrollDirection: Axis.horizontal,
            onPageChanged: (value) {
              _page = value;
              _tController.animateTo(_page,
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
            },
            children: [RecruitmentScreen(), CalculatorScreen()],
          ),
        ),
      ),
    ]);
  }
}