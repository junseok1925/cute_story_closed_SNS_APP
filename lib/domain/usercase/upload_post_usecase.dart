import 'package:cute_story_closed_sns_app/domain/entity/post.dart';
import 'package:cute_story_closed_sns_app/domain/repository/post_repository.dart';

class UploadPostUseCase {
  final PostRepository repository;

  UploadPostUseCase(this.repository);

  Future<void> call(Post post) async {
    return repository.uploadPost(post);
  }
}
