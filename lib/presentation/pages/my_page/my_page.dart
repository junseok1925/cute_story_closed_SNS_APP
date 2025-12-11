import 'package:cute_story_closed_sns_app/presentation/pages/my_page/my_page_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cute_story_closed_sns_app/domain/entity/post.dart';
import 'package:cute_story_closed_sns_app/presentation/providers.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/post_list/post_list_view_model.dart';
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
        body: SafeArea(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final currentUser = currentUserAsync.value;

    // 유저 정보 없으면
    if (currentUser == null) {
      return const Scaffold(
        body: SafeArea(
          child: Center(
            child: Text(
              "로그인 정보를 불러오지 못했습니다.",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    }

    // 🔹 3) "내가 쓴 글"만 필터 (authorId == user.id)
    final List<Post> postList =
        allPosts.where((post) => post.authorId == currentUser.id).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F0),
      appBar: AppBar(title: const Text("My Page"), centerTitle: true),
      body: SafeArea(
        child: postList.isEmpty
            ? const Center(
                child: Text(
                  "내가 작성한 게시물이 없어요 🐹",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black38,
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.1)),
        ],
      ),
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
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.delete, color: Colors.red, size: 20),
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
                      color: post.likedByMe ? Colors.red : Colors.white,
                      size: 26,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      post.likeCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 댓글 버튼
                GestureDetector(
                  onTap: () => _openCommentBottomSheet(context, post.postId),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        post.commentCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 댓글 바텀시트
  void _openCommentBottomSheet(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) {
        return MyPageBottomSheet(postId: postId);
      },
    );
  }
}
