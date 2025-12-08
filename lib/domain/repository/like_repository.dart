abstract interface class LikeRepository {
  Future<bool> isLiked(String postId, String userId);

  Future<void> addLike({
    required String postId,
    required String userId,
    required String nickname,
  });

  Future<void> removeLike(String postId, String userId);
}
