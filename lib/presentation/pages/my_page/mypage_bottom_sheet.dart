import 'package:flutter/material.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/comments/comments_page.dart';

class MyPageBottomSheet extends StatelessWidget {
  final String postId;

  const MyPageBottomSheet({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: Stack(
        children: [
          Positioned.fill(child: Container(color: Colors.transparent)),

          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (_, scrollController) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(18)),
                  ),
                  child: CommentsPage(
                    postId: postId,
                    scrollController: scrollController,
                    onClose: () => Navigator.pop(context),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}