import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cute_story_closed_sns_app/data/data_source/like_data_source.dart';
import 'package:cute_story_closed_sns_app/data/dto/like_dto.dart';
import 'package:cute_story_closed_sns_app/domain/repository/like_repository.dart';

class LikeRepositoryImpl implements LikeRepository {
  final LikeDataSource _dataSource;

  LikeRepositoryImpl(this._dataSource);

  @override
  Future<bool> isLiked(String postId, String userId) {
    return _dataSource.isLiked(postId, userId);
  }

  @override
  Future<void> addLike({
    required String postId,
    required String userId,
    required String nickname,
  }) async {
    final dto = LikeDto(
      postId: postId,
      userId: userId,
      nickname: nickname,
      createdAt: Timestamp.now(),
    );

    await _dataSource.addLike(dto);
  }

  @override
  Future<void> removeLike(String postId, String userId) async {
    await _dataSource.removeLike(postId, userId);
  }
}
