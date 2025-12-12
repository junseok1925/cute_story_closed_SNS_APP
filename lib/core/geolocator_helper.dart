import 'package:geolocator/geolocator.dart';

class GeolocatorHelper {
  static Future<Position?> getPosition() async {
    final permission = await Geolocator.checkPermission();
    // 1. 권한 없으면 요청
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // 2.권한 요청 후 결과가 거부일 때 리턴
      final permission2 = await Geolocator.requestPermission();
      if (permission2 == LocationPermission.denied ||
          permission2 == LocationPermission.deniedForever) {
        return null;
      }
    }

    // 3. Geolocator로 위치 가져와서 리턴
    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 500,
      ),
    );
    return position;
  }

  /// 거리 필터 기반 실시간 위치 스트림 (500m 기본)
  static Stream<Position> positionStream({int distanceFilter = 500}) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
      ),
    );
  }
}
