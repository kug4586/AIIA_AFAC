import 'dart:async';

import 'package:my_app/config/data.dart';
import 'package:geolocator/geolocator.dart';


///
/// 모집인원표
///

// stream controller
StreamController<String> affil_ctr = StreamController<String>.broadcast();
StreamController<String> depart_ctr = StreamController<String>.broadcast();
StreamController<String> dropdown_ctr = StreamController<String>.broadcast();

// 계열 & 학과
String? selected_affil;
String? selected_depart;

// 변경 가능한 모집인원 데이터
List<List<dynamic>> arr = recruit_data;

// 계열이 한정되면 데이터를 변경한다
void changeAffiliation(String affil) {
  if ((affil == "인문") || (affil == "자연") || (affil == "예체능")) {
    arr = recruit_data.where((row) => row[0] == affil).toList();
  }
  else {
    arr = recruit_data;
  }
}

// 학과를 골랐으면 데이터를 변경한다
void changeDepartment(String depart) {
  if (depart != "null") {
    arr = recruit_data.where((row) => row[1] == depart).toList();
  }
}


///
/// 성적 산출
///
StreamController<bool> register_ctr = StreamController<bool>.broadcast();


///
/// 위치
///
late Position pos;

// 현재 위치 찾기
Future<Position> getLocation() async {
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
}


///
/// 권한 허용
///
Future<void> authorization() async {
  bool service_enable;
  LocationPermission loca_pmis;

  service_enable = await Geolocator.isLocationServiceEnabled();
  if (!service_enable) {
    return Future.error("Location service are disable");
  }

  loca_pmis = await Geolocator.checkPermission();
  if (loca_pmis == LocationPermission.denied) {
    loca_pmis = await Geolocator.requestPermission();
    if (loca_pmis == LocationPermission.denied) {
      return Future.error("Location permissions are denied");
    }
  }

  if (loca_pmis == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }
}