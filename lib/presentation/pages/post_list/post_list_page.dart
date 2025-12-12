import 'dart:ui';

import 'package:cute_story_closed_sns_app/core/theme/app_theme.dart';
import 'package:cute_story_closed_sns_app/domain/entity/post.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/comments/comments_page.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/post_list/post_list_view_model.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/post_list/widgets/location_header.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/post_list/widgets/post_list_view.dart';
import 'package:cute_story_closed_sns_app/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListPage extends ConsumerWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postListViewModelProvider);
    final cachedAddressAsync = ref.watch(cachedAddressProvider);

    return Scaffold(
      body: Column(
        children: [
          LocationHeader(addressAsync: cachedAddressAsync),
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
    return PostListView(
      posts: posts,
      formatTime: formatTime,
      onRefresh: () =>
          ref.read(postListViewModelProvider.notifier).fetchPosts(),
      onToggleLike: (post) =>
          ref.read(postListViewModelProvider.notifier).toggleLike(post),
      onShowComments: (postId) => _showCommentsBottomSheet(context, postId),
    );
  }

  void _showCommentsBottomSheet(BuildContext context, String postId) {
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
