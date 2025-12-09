import 'package:cute_story_closed_sns_app/domain/entity/post.dart';
import 'package:cute_story_closed_sns_app/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListViewModel extends Notifier<List<Post>?> {
  @override
  List<Post>? build() {
    fetchPosts();
    return null;
  }

  /// ------------------------------
  /// Firestore 에서 게시글 불러오기
  /// ------------------------------
  Future<void> fetchPosts() async {
    final posts = await ref.read(fetchPostsUsecaseProvider).execute();
    state = posts;
  }

  /// ------------------------------
  /// 좋아요 토글 (Optimistic Update)
  /// ------------------------------
  Future<void> toggleLike(
    Post post, {
    required String userId,
    required String nickname,
  }) async {
    if (state == null) return;

    // 이전 좋아요 상태 조회
    final alreadyLiked = await ref
        .read(likeRepositoryProvider)
        .isLiked(post.postId, userId);

    final updatedPost = post.copyWith(
      likeCount: alreadyLiked ? post.likeCount - 1 : post.likeCount + 1,
    );

    final oldState = state; // 롤백 대비

    // UI 즉시 반영
    state = [
      for (final p in state!)
        if (p.postId == post.postId) updatedPost else p,
    ];

    try {
      final result = await ref
          .read(toggleLikeUsecaseProvider)
          .execute(postId: post.postId, userId: userId, nickname: nickname);

      // result == true  → 좋아요 성공
      // result == false → 좋아요 취소됨
    } catch (e) {
      // 서버 반영 실패 → UI 롤백
      state = oldState;
      rethrow;
    }
  }
}

/// Provider
final postListViewModelProvider =
    NotifierProvider<PostListViewModel, List<Post>?>(() {
      return PostListViewModel();
    });
