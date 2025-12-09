import 'package:cute_story_closed_sns_app/domain/repository/post_repository.dart';

class AddLikeUsecase {
  AddLikeUsecase(this._repository);

  final PostRepository _repository;

  Future<void> execute({
    required String postId,
    required String userId,
    required String nickname,
    required DateTime createdAt,
  }) {
    return _repository.addLike(
      postId: postId,
      userId: userId,
      nickname: nickname,
      createdAt: createdAt,
    );
  }
}
