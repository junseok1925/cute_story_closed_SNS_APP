import 'package:cute_story_closed_sns_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cute_story_closed_sns_app/domain/entity/post.dart';
import 'package:cute_story_closed_sns_app/presentation/providers.dart';

class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postList = ref.watch(myPageViewModelProvider);

    return Scaffold(
      backgroundColor: vrc(context).background100,
      body: SafeArea(
        child: ListView.builder(
          itemCount: postList.length,
          itemBuilder: (context, index) {
            final post = postList[index];
            return Padding(
              padding: const EdgeInsets.all(12),
              child: item(context, ref, post),
            );
          },
        ),
      ),
    );
  }

  Widget item(BuildContext context, WidgetRef ref, Post post) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: vrc(context).background200,
      ),
      child: Stack(
        children: [
          // ✅ 이미지
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              post.mediaUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // ✅ 삭제 버튼
          Positioned(
            top: 10,
            left: 10,
            child: GestureDetector(
              onTap: () {
                print("🔥 UI에서 삭제 버튼 눌림: ${post.postId}");
                ref
                    .read(myPageViewModelProvider.notifier)
                    .deletePost(post.postId);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: vrc(context).background200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    Icon(Icons.delete, color: fxc(context).brandColor, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
