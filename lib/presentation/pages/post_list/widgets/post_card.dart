import 'dart:ui';

import 'package:cute_story_closed_sns_app/core/theme/app_theme.dart';
import 'package:cute_story_closed_sns_app/domain/entity/post.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/comments/comments_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PostCard extends ConsumerWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.minOverlayHeight,
    required this.onToggleLike,
    required this.onShowComments,
    required this.formatTime,
  });

  final Post post;
  final double minOverlayHeight;
  final VoidCallback onToggleLike;
  final VoidCallback onShowComments;
  final String Function(DateTime) formatTime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      fit: StackFit.expand,
      children: [_buildBackground(context), _buildOverlay(context, ref)],
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            post.mediaUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: Colors.white10),
                  const Center(
                    child: SpinKitRing(
                      color: Colors.white,
                      size: 56,
                      lineWidth: 5,
                      duration: Duration(milliseconds: 1200),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay(BuildContext context, WidgetRef ref) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
        constraints: BoxConstraints(minHeight: minOverlayHeight),
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
                color: Colors.black.withAlpha(60),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildMetaRow(context, ref),
                  const SizedBox(height: 10),
                  _buildAuthor(context),
                  const SizedBox(height: 6),
                  _buildContent(context),
                  _buildLocation(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetaRow(BuildContext context, WidgetRef ref) {
    final commentCountAsync = ref.watch(commentCountProvider(post.postId));
    return Row(
      children: [
        Text(
          formatTime(post.createdAt),
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onToggleLike,
          child: Row(
            children: [
              Icon(
                post.likedByMe ? Icons.favorite : Icons.favorite_border,
                size: 28,
                color: post.likedByMe ? fxc(context).brandColor : Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                post.likeCount.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: onShowComments,
          child: Row(
            children: [
              Icon(Icons.comment, size: 28, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                commentCountAsync.maybeWhen(
                  data: (count) => count.toString(),
                  orElse: () => post.commentCount.toString(),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAuthor(BuildContext context) {
    return Text(
      post.nickname,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 17,
        color: Colors.white,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Text(
      post.content,
      style: TextStyle(fontSize: 15, color: Colors.white),
    );
  }

  Widget _buildLocation(BuildContext context) {
    if (post.location == null || post.location!.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(Icons.location_on, size: 16, color: vrc(context).textColor100),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              post.location!,
              style: TextStyle(fontSize: 12, color: vrc(context).textColor100),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
