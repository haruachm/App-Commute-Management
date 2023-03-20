// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final LatLng schoolLatlng = LatLng(
    //위도와 경도 값 지정
    37.540853,
    127.078971,
  );

  static final CameraPosition initialPosition = CameraPosition(
    //지도를 바라보는 카메라 위치
    target: schoolLatlng, //카메라 위치(위도, 경도)
    zoom: 15, //확대 정도
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: Column(
        children: [
          _CustomGoogleMap(initialPosition: initialPosition),
          //_CommuteCheckButton(),
        ],
      ),
    );
  }

  Future<String> checkPermission() async {
    //위치 서비스 활성화 여부
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      //위치 서비스가 꺼져있다면 에러 메시지 리턴
      return '위치 서비스를 활성화 해주세요.';
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();
    //처음 앱 실행 상태
    if (checkedPermission == LocationPermission.denied) {
      //권한 요청 다이어로그를 띄움
      checkedPermission = await Geolocator.requestPermission();
      if (checkedPermission == LocationPermission.denied) {
        return '위치 권한을 허용해주세요.';
      }
    }

    if (checkedPermission == LocationPermission.deniedForever) {
      return '설정에서 앱의 위치 권한 허용으로 설정해주세요.';
    }
    return '위치 권한이 허가되었습니다.';
  }

  AppBar renderAppBar() {
    return AppBar(
      title: Text(
        '구글지도로 보는 학교',
        style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
    );
  }
}

class _CustomGoogleMap extends StatelessWidget {
  final CameraPosition initialPosition;

  const _CustomGoogleMap({required this.initialPosition, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: GoogleMap(
        //구글 맵 사용
        mapType: MapType.terrain, //지도 유형 설정
        initialCameraPosition: initialPosition, //지도 초기 위치 설정
      ),
    );
  }
}

class _CommuteCheckButton extends StatelessWidget {
  const _CommuteCheckButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text('출근'),
    );
  }
}
