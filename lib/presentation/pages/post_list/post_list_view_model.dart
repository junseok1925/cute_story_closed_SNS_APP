import 'package:cute_story_closed_sns_app/domain/entity/post.dart';
import 'package:cute_story_closed_sns_app/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListViewModel extends Notifier<List<Post>?> {
  @override
  List<Post>? build() {
    fetchPosts(); // 첫 로딩 시 자동 호출
    return null;
  }

  Future<void> fetchPosts() async {
    state = await ref.read(fetchPostsUsecaseProvider).execute();
  }
}

final postListViewModelProvider =
    NotifierProvider<PostListViewModel, List<Post>?>(() => PostListViewModel());
