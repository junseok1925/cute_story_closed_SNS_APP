import 'package:cute_story_closed_sns_app/domain/repository/like_repository.dart';

class ToggleLikeUsecase {
  final LikeRepository _repo;

  ToggleLikeUsecase(this._repo);

  Future<bool> execute({
    required String postId,
    required String userId,
    required String nickname,
  }) async {
    final alreadyLiked = await _repo.isLiked(postId, userId);

    if (alreadyLiked) {
      await _repo.removeLike(postId, userId);
      return false; // 좋아요 취소됨
    } else {
      await _repo.addLike(postId: postId, userId: userId, nickname: nickname);
      return true; // 좋아요 성공
    }
  }
}
