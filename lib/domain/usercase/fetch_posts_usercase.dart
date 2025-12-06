import 'package:cute_story_closed_sns_app/domain/entity/post.dart';
import 'package:cute_story_closed_sns_app/domain/repository/post_repository.dart';

class FetchPostsUsecase {
  FetchPostsUsecase(this._postRepository);

  final PostRepository _postRepository;

  Future<List<Post>> execute({int limit = 10, DateTime? startAfter}) async {
    return await _postRepository.fetchPosts(
      limit: limit,
      startAfter: startAfter,
    );
  }
}
