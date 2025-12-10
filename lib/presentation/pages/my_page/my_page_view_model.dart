import 'package:flutter_riverpod/legacy.dart';
import '../../../domain/entity/post.dart';
import '../../../domain/repository/post_repository.dart';
import '../../../domain/usercase/fetch_posts_usercase.dart';

class MyPageViewModel extends StateNotifier<List<Post>> {
  final FetchPostsUsecase _fetchPostsUsecase;
  final PostRepository _postRepository;

  MyPageViewModel(
    this._fetchPostsUsecase,
    this._postRepository,
  ) : super([]) {
    fetchPosts();
  }

  // ✅ 게시글 전체 불러오기
  Future<void> fetchPosts() async {
    final posts = await _fetchPostsUsecase.execute();
    state = posts;
  }

  // ✅ 게시글 삭제 (Firestore + UI)
  Future<void> deletePost(String postId) async {
    print("🔥 ViewModel deletePost 실행: $postId");
    await _postRepository.deletePost(postId); // Firestore 삭제
    await fetchPosts(); // UI 갱신
  }
}
