import 'package:cute_story_closed_sns_app/domain/repository/comment_repository.dart';

class UpdateCommentUsecase {
  final CommentRepository _repo;
  UpdateCommentUsecase(this._repo);

  Future<void> execute(String postId, String commentId, String content) async {
    await _repo.updateComment(postId, commentId, content);
  }
}

class DeleteCommentUsecase {
  final CommentRepository _repo;
  DeleteCommentUsecase(this._repo);

  Future<void> execute(String postId, String commentId) async {
    await _repo.deleteComment(postId, commentId);
  }
}
