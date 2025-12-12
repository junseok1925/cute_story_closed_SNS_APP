import 'dart:ui';
import 'package:cute_story_closed_sns_app/core/theme/app_theme.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/comments/comments_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cute_story_closed_sns_app/domain/entity/post.dart';
import 'package:cute_story_closed_sns_app/presentation/providers.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/post_list/post_list_view_model.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/comments/comments_view_model.dart';

class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ 마이페이지가 빌드될 때마다 최신 posts 다시 불러오기
    Future.microtask(() {
      ref.read(myPageViewModelProvider.notifier).fetchPosts();
    });

    // 🔹 1) 전체 포스트는 MyPageViewModel에서 받아옴
    final allPosts = ref.watch(myPageViewModelProvider);

    // 🔹 2) 현재 로그인한 유저 (AddPage랑 똑같이 currentUserProvider 사용)
    final currentUserAsync = ref.watch(currentUserProvider);

    // 로딩 중일 때
    if (currentUserAsync.isLoading) {
      return const Scaffold(
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    final currentUser = currentUserAsync.value;

    // 유저 정보 없으면
    if (currentUser == null) {
      return const Scaffold(
        body: SafeArea(
          child: Center(
            child: Text("로그인 정보를 불러오지 못했습니다.", style: TextStyle(fontSize: 16)),
          ),
        ),
      );
    }

    // 🔹 3) "내가 쓴 글"만 필터 (authorId == user.id)
    final List<Post> postList = allPosts
        .where((post) => post.authorId == currentUser.id)
        .toList();

    return Scaffold(
      backgroundColor: vrc(context).background100,
      appBar: AppBar(
        title: const Text("My Page"),
        centerTitle: true,
        backgroundColor: vrc(context).background100,
      ),
      body: SafeArea(
        child: postList.isEmpty
            ? Center(
                child: Text(
                  "내가 작성한 게시물이 없어요 🐹",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: vrc(context).textColor100,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: postList.length,
                itemBuilder: (context, index) {
                  final post = postList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _postItem(context, ref, post),
                  );
                },
              ),
      ),
    );
  }

  /// 게시글 카드
  Widget _postItem(BuildContext context, WidgetRef ref, Post post) {
    return Container(
      height: 160,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
      child: Stack(
        children: [
          /// 이미지
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              post.mediaUrl.trim(),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Center(child: Icon(Icons.broken_image, size: 40)),
            ),
          ),

          /// 삭제 버튼 (Firestore + UI 동기화 + 홈 리스트 갱신)
          Positioned(
            top: 10,
            left: 10,
            child: GestureDetector(
              onTap: () async {
                // 1️⃣ 마이페이지쪽 ViewModel + Firestore에서 삭제
                await ref
                    .read(myPageViewModelProvider.notifier)
                    .deletePost(post.postId);

                // 2️⃣ 홈(PostListPage)에서 사용하는 리스트도 새로고침
                ref.invalidate(postListViewModelProvider);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: vrc(context).background200!.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.delete,
                  color: fxc(context).brandColor,
                  size: 20,
                ),
              ),
            ),
          ),

          /// 좋아요 + 댓글
          Positioned(
            right: 14,
            bottom: 12,
            child: Column(
              children: [
                // 좋아요 표시
                Column(
                  children: [
                    Icon(
                      post.likedByMe ? Icons.favorite : Icons.favorite_border,
                      color: post.likedByMe
                          ? Colors.red
                          : vrc(context).textColor200,
                      size: 26,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      post.likeCount.toString(),
                      style: TextStyle(
                        color: vrc(context).textColor200,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 댓글 버튼
                Consumer(
                  builder: (context, ref, _) {
                    final commentCountAsync = ref.watch(
                      commentCountProvider(post.postId),
                    );
                    final count = commentCountAsync.maybeWhen(
                      data: (c) => c,
                      orElse: () => post.commentCount,
                    );
                    return GestureDetector(
                      onTap: () =>
                          _openCommentBottomSheet(context, post.postId),
                      child: Column(
                        children: [
                          Icon(
                            Icons.comment,
                            color: vrc(context).textColor200,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            count.toString(),
                            style: TextStyle(
                              color: vrc(context).textColor200,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // _openCommentBottomSheet
  /// 댓글 바텀시트
  void _openCommentBottomSheet(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54, // 주변 dim만 유지
      builder: (_) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context), // 배경 탭 → 닫기
          child: Stack(
            children: [
              Positioned.fill(child: Container()),

              // ▼ ▼ 블러 + 투명 바텀시트 ▼ ▼
              DraggableScrollableSheet(
                initialChildSize: 0.65,
                minChildSize: 0.5,
                maxChildSize: 0.9,
                builder: (_, scrollController) {
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {}, // 시트 내부는 닫히지 않음
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: vrc(
                              context,
                            ).background200!.withValues(alpha: 0.7),
                            // → 30% 투명 + 블러
                          ),
                          child: CommentsPage(
                            postId: postId,
                            scrollController: scrollController,
                            onClose: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
