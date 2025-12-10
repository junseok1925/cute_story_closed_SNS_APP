import 'dart:ui';

import 'package:cute_story_closed_sns_app/core/theme/app_theme.dart';
import 'package:cute_story_closed_sns_app/domain/entity/post.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/comments/comments_page.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/post_list/post_list_view_model.dart';
import 'package:cute_story_closed_sns_app/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:ui';

class PostListPage extends ConsumerWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postListViewModelProvider);
    final cachedAddressAsync = ref.watch(cachedAddressProvider);

    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 18,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      cachedAddressAsync.when(
                        data: (addr) => addr ?? '주소 없음',
                        loading: () => '주소 불러오는 중...',
                        error: (_, __) => '주소 불러오기 실패',
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: _buildFullPagePosts(context, ref, posts)),
        ],
      ),
    );
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

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(postListViewModelProvider.notifier).fetchPosts(),
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        pageSnapping: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];

          return Stack(
            fit: StackFit.expand,
            children: [
              /// 배경 이미지
              Positioned.fill(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Container(color: Colors.white),
                    Image.network(
                      post.mediaUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            // 로딩 중에도 살짝 어둡게 깔린 배경
                            Container(color: Colors.white10),
                            Center(
                              child: SpinKitRing(
                                color: Colors.white,
                                size: 56,
                                lineWidth: 5,
                                duration: const Duration(milliseconds: 1200),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              /// 하단 오버레이
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                  constraints: BoxConstraints(minHeight: screenHeight * 0.2),

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, vrc(context).shadow!],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(60), // 글자 가독성 증가
                          borderRadius: BorderRadius.circular(12),
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
                                        style: TextStyle(
                                          color: vrc(context).textColor200,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 16),

                                GestureDetector(
                                  onTap: () => _showCommentsBottomSheet(
                                    context,
                                    post.postId,
                                  ),
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
                                        style: TextStyle(
                                          color: vrc(context).textColor200,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),
                            // 게시글 작성자 닉넴
                            Text(
                              post.nickname,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: vrc(context).textColor200,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // 게시글 내용
                            Text(
                              post.content,
                              style: TextStyle(
                                fontSize: 15,
                                color: vrc(context).textColor200,
                              ),
                            ),
                            Text(
                              post.content,
                              style: TextStyle(
                                fontSize: 15,
                                color: vrc(context).textColor200,
                              ),
                            ),
                            // 게시글 작성된 주소
                            if (post.location != null &&
                                post.location!.trim().isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: vrc(context).textColor100,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      post.location!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: vrc(context).textColor100,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54, // 주변 dim만 유지
      builder: (ctx) {
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
