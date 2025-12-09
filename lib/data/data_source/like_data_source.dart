import 'package:cute_story_closed_sns_app/data/dto/like_dto.dart';

abstract interface class LikeDataSource {
  Future<bool> isLiked(String postId, String userId);

  Future<void> addLike(LikeDto dto);

  Future<void> removeLike(String postId, String userId);
}
