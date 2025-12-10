import 'package:cute_story_closed_sns_app/core/theme/app_theme.dart';
import 'package:cute_story_closed_sns_app/domain/entity/post.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/comments/comments_page.dart';
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

            /// 하단 오버레이
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                constraints: BoxConstraints(minHeight: screenHeight * 0.32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, vrc(context).shadow!],
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
                          style: TextStyle(
                            fontSize: 12,
                            color: vrc(context).textColor200,
                          ),
                        ),
                        const Spacer(),

                        /// 좋아요 버튼
                        GestureDetector(
                          onTap: () => ref
                              .read(postListViewModelProvider.notifier)
                              .toggleLike(post),
                          child: Row(
                            children: [
                              Icon(
                                post.likedByMe
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 28,
                                color: post.likedByMe
                                    ? fxc(context).brandColor
                                    : vrc(context).textColor200,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                post.likeCount.toString(),
                                style: TextStyle(color: vrc(context).textColor200),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        /// 댓글 버튼
                        GestureDetector(
                          onTap: () {
                            _showCommentsBottomSheet(context, post.postId);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.comment,
                                size: 28,
                                color: vrc(context).textColor200,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                post.commentCount.toString(),
                                style: TextStyle(color: vrc(context).textColor200),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: vrc(context).textColor200,
                      ),
                    ),
                    const SizedBox(height: 6),

                    /// 게시글 내용
                    Text(
                      post.content,
                      style: TextStyle(fontSize: 15, color: vrc(context).textColor200),
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

  void _showCommentsBottomSheet(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // 배경을 투명하게 유지
      barrierColor: vrc(context).shadow, // dim 효과
      builder: (ctx) {
        // 배경 클릭시에도 닫히게 GestureDetector로 처리
        return GestureDetector(
          behavior: HitTestBehavior.opaque, // 빈 공간 터치 감지
          onTap: () => Navigator.pop(context), // 배경 탭 -> 닫힘
          child: Stack(
            children: [
              Positioned.fill(child: Container(color: Colors.transparent)),

              /// 여기가 댓글 BottomSheet
              DraggableScrollableSheet(
                initialChildSize: 0.65,
                minChildSize: 0.5,
                maxChildSize: 0.9,
                builder: (_, scrollController) {
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {}, // 시트 내부는 닫히지 않도록
                    child: Container(
                      decoration: BoxDecoration(
                        color: vrc(context).background200!.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                      ),
                      child: CommentsPage(
                        postId: postId,
                        scrollController:
                            scrollController, // 전달 필수 -> 스크롤 내려서 닫히게
                        onClose: () => Navigator.of(context).pop(),
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
