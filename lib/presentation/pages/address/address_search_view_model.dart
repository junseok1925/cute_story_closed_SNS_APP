import 'package:flutter_riverpod/legacy.dart';
import 'package:cute_story_closed_sns_app/core/geolocator_helper.dart';
import 'package:cute_story_closed_sns_app/data/repository/vworld_repository.dart';

class AddressSearchViewModel extends StateNotifier<List<String>> {
  AddressSearchViewModel(this._repo) : super([]) {
    fetchMyAddress();
  }

  final VWorldRepository _repo;

  Future<void> fetchMyAddress() async {
    final pos = await GeolocatorHelper.getPosition();
    if (pos == null) {
      state = ["위치 권한 거부됨"];
      return;
    }

    final result = await _repo.findByLatLng(
      lat: pos.latitude,
      lng: pos.longitude,
    );

    state = result.isEmpty ? ["주소 없음"] : result;
  }
}

final addressSearchViewModel = StateNotifierProvider.autoDispose<
    AddressSearchViewModel, List<String>>((ref) {
  return AddressSearchViewModel(VWorldRepository());
});
