import 'package:cute_story_closed_sns_app/domain/entity/post.dart';
import 'package:cute_story_closed_sns_app/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListViewModel extends Notifier<List<Post>?> {
  @override
  List<Post>? build() {
    fetchPosts();
    return null;
  }

  /// Firestore 에서 게시글 불러오기
  Future<void> fetchPosts() async {
    const mockUserId = 'testUser1';

    final posts = await ref.read(fetchPostsUsecaseProvider).execute();

    // 각 게시물에 대해 내가 이미 좋아요 했는지 확인 (mockUserId 기준)
    final repo = ref.read(postRepositoryProvider);
    final updated = await Future.wait(
      posts.map((post) async {
        final liked = await repo.isLiked(
          postId: post.postId,
          userId: mockUserId,
        );
        return post.copyWith(likedByMe: liked);
      }),
    );

    state = updated;
  }

  /// 좋아요 추가 (단순 +1)
  Future<void> toggleLike(Post target) async {
    // 테스트 목데이터
    const mockUserId = 'testUser1';
    const mockNickname = '강준석';

    final isLikedNow = await ref
        .read(toggleLikeUsecaseProvider)
        .execute(
          postId: target.postId,
          userId: mockUserId,
          nickname: mockNickname,
        );

    // 로컬 상태도 즉시 반영 (isLikedNow true면 +1, false면 -1)
    final current = state;
    if (current == null) return;
    state = current
        .map(
          (post) => post.postId == target.postId
              ? post.copyWith(
                  likeCount: post.likeCount + (isLikedNow ? 1 : -1),
                  likedByMe: isLikedNow,
                )
              : post,
        )
        .toList();
  }
}

/// Provider
final postListViewModelProvider =
    NotifierProvider<PostListViewModel, List<Post>?>(() {
      return PostListViewModel();
    });
