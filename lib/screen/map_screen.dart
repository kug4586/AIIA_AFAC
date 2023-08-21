import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import 'package:my_app/config/interface.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("지도"),
        backgroundColor: Colors.blue,
      ),
      body: NaverMap(
          options: NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(
              target: NLatLng(pos.latitude, pos.longitude),
              zoom: 17.0
            )
          ),
          onMapReady: (controller) {
            print("네이버 맵 로딩됨!");
          }
      )
    );
  }
}