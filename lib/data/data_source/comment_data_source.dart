import 'package:cute_story_closed_sns_app/data/dto/comment_dto.dart';

abstract interface class CommentDataSource {
  Future<List<CommentDto>> fetchComments(String postId);
  Future<void> addComment(CommentDto dto);
  Future<void> updateComment(String postId, String commentId, String content);
  Future<void> deleteComment(String postId, String commentId);
  Stream<List<CommentDto>> commentsStream(String postId);
}
