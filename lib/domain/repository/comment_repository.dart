import 'package:cute_story_closed_sns_app/domain/entity/comment.dart';

abstract interface class CommentRepository {
  Future<List<Comment>> fetchComments(String postId);
  Stream<List<Comment>> commentsStream(String postId);
  Future<void> addComment(Comment comment);
  Future<void> updateComment(String postId, String commentId, String content);
  Future<void> deleteComment(String postId, String commentId);
}
