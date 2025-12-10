import 'package:cute_story_closed_sns_app/data/repository/vworld_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final vWorldRepository = VWorldRepository();
  test('VWorldRepository : findByName', () async {
    final result = await vWorldRepository.findByName('온천동');
    expect(result.length, 2);
    expect(result.where((e) => e.contains('온천동')).length, 2);

    final result2 = await vWorldRepository.findByName('asd');
    expect(result2.length, 0);
  });

  test('VWorldRepository : findByLatLng', () async {
    final result = await vWorldRepository.findByLatLng(
      lat: 35.2202216,
      lng: 129.0823133,
    );
    expect(result.first, '부산광역시 동래구 온천동');

    final result2 = await vWorldRepository.findByLatLng(
      lat: 32.2202216,
      lng: 129.0823133,
    );
    expect(result2.length, 0);
  });
}
