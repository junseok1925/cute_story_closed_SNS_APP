import 'dart:async';

import 'package:cute_story_closed_sns_app/core/geolocator_helper.dart';
import 'package:cute_story_closed_sns_app/data/repository/vworld_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 위치→주소를 가져와 캐싱하고, 500m 이동 시마다 갱신하는 전역 매니저.
class LocationCacheManager {
  LocationCacheManager._();

  static const _cacheKey = 'cached_address';
  static StreamSubscription<Position>? _sub;
  static bool _started = false;

  /// 1) 캐시된 주소 출력 2) 현재 위치/주소 조회 3) 500m 이동 스트림 구독
  static Future<void> start() async {
    if (_started) return;
    _started = true;

    try {
      final prefs = await SharedPreferences.getInstance();

      final cached = prefs.getString(_cacheKey);
      if (cached != null && cached.isNotEmpty) {
        debugPrint('캐시된 주소: $cached');
      }

      final pos = await GeolocatorHelper.getPosition();
      if (pos == null) {
        debugPrint('위치 권한 거부됨');
      } else {
        await _updateAddress(lat: pos.latitude, lng: pos.longitude, prefs: prefs);
      }

      _sub = GeolocatorHelper.positionStream().listen((position) {
        _updateAddress(
          lat: position.latitude,
          lng: position.longitude,
          prefs: prefs,
        );
      });
    } catch (e) {
      debugPrint('위치/주소 매니저 오류: $e');
      _started = false; // 실패 시 재시도 가능하도록 플래그 해제
    }
  }

  static Future<void> _updateAddress({
    required double lat,
    required double lng,
    required SharedPreferences prefs,
  }) async {
    final result = await VWorldRepository().findByLatLng(lat: lat, lng: lng);
    if (result.isEmpty) {
      debugPrint('주소를 찾지 못했습니다.');
      return;
    }
    final first = result.first;
    await prefs.setString(_cacheKey, first);
    debugPrint('주소 갱신: $first');
  }

  /// 앱 종료 시 스트림 정리할 때 사용 가능.
  static Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
    _started = false;
  }
}
