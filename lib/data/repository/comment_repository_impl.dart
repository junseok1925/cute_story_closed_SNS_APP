import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cute_story_closed_sns_app/data/data_source/comment_data_source.dart';
import 'package:cute_story_closed_sns_app/data/dto/comment_dto.dart';
import 'package:cute_story_closed_sns_app/domain/entity/comment.dart';
import 'package:cute_story_closed_sns_app/domain/repository/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  @override
  Stream<List<Comment>> commentsStream(String postId) {
    return _dataSource
        .commentsStream(postId)
        .map(
          (dtos) => dtos
              .map(
                (dto) => Comment(
                  commentId: dto.commentId,
                  postId: dto.postId,
                  userId: dto.userId,
                  nickname: dto.nickname,
                  content: dto.content,
                  createdAt: dto.createdAt.toDate(),
                ),
              )
              .toList(),
        );
  }

  final CommentDataSource _dataSource;
  CommentRepositoryImpl(this._dataSource);

  @override
  Future<List<Comment>> fetchComments(String postId) async {
    final dtos = await _dataSource.fetchComments(postId);
    return dtos
        .map(
          (dto) => Comment(
            commentId: dto.commentId,
            postId: dto.postId,
            userId: dto.userId,
            nickname: dto.nickname,
            content: dto.content,
            createdAt: dto.createdAt.toDate(),
          ),
        )
        .toList();
  }

  @override
  Future<void> addComment(Comment comment) async {
    final dto = CommentDto(
      postId: comment.postId,
      userId: comment.userId,
      nickname: comment.nickname,
      content: comment.content,
      createdAt: Timestamp.fromDate(comment.createdAt),
    );
    await _dataSource.addComment(dto);
  }

  @override
  Future<void> updateComment(
    String postId,
    String commentId,
    String content,
  ) async {
    await _dataSource.updateComment(postId, commentId, content);
  }

  Future<void> deleteComment(String postId, String commentId) async {
    await _dataSource.deleteComment(postId, commentId);
  }
}
