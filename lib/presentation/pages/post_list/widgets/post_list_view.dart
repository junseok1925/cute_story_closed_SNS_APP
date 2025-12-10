import 'package:cute_story_closed_sns_app/domain/entity/post.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/post_list/widgets/post_card.dart';
import 'package:flutter/material.dart';

class PostListView extends StatelessWidget {
  const PostListView({
    super.key,
    required this.posts,
    required this.formatTime,
    required this.onRefresh,
    required this.onToggleLike,
    required this.onShowComments,
  });

  final List<Post>? posts;
  final String Function(DateTime) formatTime;
  final Future<void> Function() onRefresh;
  final void Function(Post) onToggleLike;
  final void Function(String postId) onShowComments;

  @override
  Widget build(BuildContext context) {
    if (posts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (posts!.isEmpty) {
      return const Center(child: Text('게시물이 없습니다.'));
    }

    final screenHeight = MediaQuery.of(context).size.height;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        pageSnapping: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: posts!.length,
        itemBuilder: (context, index) {
          final post = posts![index];
          return PostCard(
            post: post,
            minOverlayHeight: screenHeight * 0.2,
            formatTime: formatTime,
            onToggleLike: () => onToggleLike(post),
            onShowComments: () => onShowComments(post.postId),
          );
        },
      ),
    );
  }
}
