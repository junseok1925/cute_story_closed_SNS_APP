import 'package:cute_story_closed_sns_app/domain/entity/post.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/post_list/post_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListPage extends ConsumerWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postListViewModelProvider);

    return Scaffold(body: _buildFullPagePosts(context, ref, posts));
  }

  String formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);

    if (diff.inMinutes < 1) return "방금 전";
    if (diff.inMinutes < 60) return "${diff.inMinutes}분 전";
    if (diff.inHours < 24) return "${diff.inHours}시간 전";
    if (diff.inDays < 7) return "${diff.inDays}일 전";
    return "${dt.year}.${dt.month}.${dt.day}";
  }

  Widget _buildFullPagePosts(
    BuildContext context,
    WidgetRef ref,
    List<Post>? posts,
  ) {
    if (posts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (posts.isEmpty) {
      return const Center(child: Text('게시물이 없습니다.'));
    }

    final screenHeight = MediaQuery.of(context).size.height;

    return PageView.builder(
      scrollDirection: Axis.vertical,
      pageSnapping: true,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];

        return Stack(
          fit: StackFit.expand,
          children: [
            /// 배경 이미지
            Positioned.fill(
              child: Image.network(post.mediaUrl, fit: BoxFit.cover),
            ),

            /// ⬆⬇ 하단 오버레이 UI
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                constraints: BoxConstraints(minHeight: screenHeight * 0.2),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black87],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// 날짜 + 좋아요 + 댓글 Row
                    Row(
                      children: [
                        Text(
                          formatTime(post.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        const Spacer(),

                        /// 좋아요 버튼
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(postListViewModelProvider.notifier)
                                .toggleLike(
                                  post,
                                  userId: "testUser1",
                                  nickname: "강준석",
                                );
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                size: 28,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                post.likeCount.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        /// 댓글 버튼
                        GestureDetector(
                          onTap: () {
                            print("댓글 페이지로 이동 예정: ${post.postId}");
                            // Navigator.push(context, MaterialPageRoute(
                            //   builder: (_) => CommentPage(postId: post.postId),
                            // ));
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.comment,
                                size: 28,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                post.commentCount.toString(),
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// 닉네임
                    Text(
                      post.nickname,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),

                    /// 게시글 내용
                    Text(
                      post.content,
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
