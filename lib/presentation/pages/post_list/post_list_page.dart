import 'package:cute_story_closed_sns_app/presentation/pages/post_list/post_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('게시글 목록')),
      body: Consumer(
        builder: (context, ref, child) {
          final posts = ref.watch(postListViewModelProvider);

          if (posts == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // 게시물이 없을 경우 UI
          if (posts.isEmpty) {
            return const Center(child: Text('게시물이 없습니다.'));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 이미지 영역
                    AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Image.network(post.mediaUrl, fit: BoxFit.cover),
                    ),

                    const SizedBox(height: 10),

                    // 닉네임
                    Text(
                      post.nickname,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // 내용
                    Text(post.content, style: const TextStyle(fontSize: 14)),

                    const SizedBox(height: 5),

                    // 좋아요/댓글 수
                    Row(
                      children: [
                        Icon(Icons.favorite, size: 16, color: Colors.red),
                        SizedBox(width: 4),
                        Text(post.likeCount.toString()),

                        SizedBox(width: 12),
                        Icon(Icons.comment, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(post.commentCount.toString()),
                      ],
                    ),

                    const SizedBox(height: 5),

                    // 업로드 날짜
                    Text(
                      post.createdAt.toString(),
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
