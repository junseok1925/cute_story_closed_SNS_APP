

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cute_story_closed_sns_app/domain/entity/post.dart';
import 'package:cute_story_closed_sns_app/presentation/providers.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/post_list/post_list_view_model.dart';

//  방금 만든 바텀시트 위젯 import
import 'package:cute_story_closed_sns_app/presentation/pages/my_page/my_page_bottom_sheet.dart';

class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Home(PostList)와 같은 데이터를 그대로 사용
    final postList = ref.watch(postListViewModelProvider) ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F0),
      appBar: AppBar(
        title: const Text("My Page"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
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

  /// ✅ 게시글 카드
  Widget _postItem(BuildContext context, WidgetRef ref, Post post) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Stack(
        children: [
          /// ✅ 이미지
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

          /// ✅ 삭제 (Firestore + UI동기화)
          Positioned(
            top: 10,
            left: 10,
            child: GestureDetector(
              onTap: () {
                ref
                    .read(myPageViewModelProvider.notifier)
                    .deletePost(post.postId);
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

          /// ✅ 좋아요 + 댓글
          Positioned(
            right: 14,
            bottom: 12,
            child: Column(
              children: [
                /// ✅ 좋아요 (읽기 전용 표시)
                Column(
                  children: [
                    Icon(
                      post.likedByMe
                          ? Icons.favorite
                          : Icons.favorite_border,
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

                /// ✅ 댓글 버튼 (누르면 바텀시트 열림)
                GestureDetector(
                  onTap: () => _openCommentBottomSheet(
                    context,
                    post.postId,
                  ),
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

  ///  댓글 바텀시트 오픈 (바깥 클릭 시 닫힘)
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