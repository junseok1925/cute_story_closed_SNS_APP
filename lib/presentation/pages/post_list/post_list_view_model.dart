import 'package:cute_story_closed_sns_app/domain/entity/post.dart';
import 'package:cute_story_closed_sns_app/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListViewModel extends Notifier<List<Post>?> {
  String? _currentUserId;
  String? _currentNickname;

  @override
  List<Post>? build() {
    fetchPosts();
    return null;
  }

  /// Firestore 에서 게시글 불러오기
  Future<void> fetchPosts() async {
    // 로그인 유저 정보 확보
    _currentUserId ??= await ref.read(firebaseUserIdProvider.future);
    _currentNickname ??= await ref.read(currentUserNicknameProvider.future);

    final userId = _currentUserId;
    final locationRaw = await ref.read(cachedAddressProvider.future);
    final location = (locationRaw == null || locationRaw.trim().isEmpty)
        ? null
        : locationRaw.trim();

    final posts = await ref
        .read(fetchPostsUsecaseProvider)
        .execute(location: location);

    // 각 게시물에 대해 내가 이미 좋아요 했는지 확인
    final repo = ref.read(postRepositoryProvider);
    final updated = await Future.wait(
      posts.map((post) async {
        if (userId == null) {
          return post;
        }
        final liked = await repo.isLiked(
          postId: post.postId,
          userId: userId,
        );
        return post.copyWith(likedByMe: liked);
      }),
    );

    state = updated;
  }

  /// 좋아요 추가 (단순 +1)
  Future<void> toggleLike(Post target) async {
    _currentUserId ??= await ref.read(firebaseUserIdProvider.future);
    _currentNickname ??= await ref.read(currentUserNicknameProvider.future);
    final userId = _currentUserId;
    final nickname = _currentNickname;

    if (userId == null || nickname == null) return;

    final isLikedNow = await ref
        .read(toggleLikeUsecaseProvider)
        .execute(
          postId: target.postId,
          userId: userId,
          nickname: nickname,
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
