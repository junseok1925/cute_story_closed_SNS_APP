import 'package:cute_story_closed_sns_app/domain/entity/comment.dart';
import 'package:cute_story_closed_sns_app/domain/repository/comment_repository.dart';

class FetchCommentsUsecase {
  final CommentRepository _repo;
  FetchCommentsUsecase(this._repo);

  Future<List<Comment>> execute(String postId) async {
    return await _repo.fetchComments(postId);
  }
}

class AddCommentUsecase {
  final CommentRepository _repo;
  AddCommentUsecase(this._repo);

  Future<void> execute(Comment comment) async {
    await _repo.addComment(comment);
  }
}
