import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cute_story_closed_sns_app/data/data_source/like_data_source.dart';
import 'package:cute_story_closed_sns_app/data/dto/like_dto.dart';

class LikeDataSourceImpl implements LikeDataSource {
  final _db = FirebaseFirestore.instance;

  CollectionReference get _likes => _db.collection('likes');

  @override
  Future<bool> isLiked(String postId, String userId) async {
    final query = await _likes
        .where('postId', isEqualTo: postId)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }

  @override
  Future<void> addLike(LikeDto dto) async {
    await _likes.add(dto.toJson());
  }

  @override
  Future<void> removeLike(String postId, String userId) async {
    final query = await _likes
        .where('postId', isEqualTo: postId)
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in query.docs) {
      await doc.reference.delete();
    }
  }
}
