import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cute_story_closed_sns_app/data/data_source/comment_data_source.dart';
import 'package:cute_story_closed_sns_app/data/dto/comment_dto.dart';

class CommentDataSourceImpl implements CommentDataSource {
  final FirebaseFirestore _firestore;
  CommentDataSourceImpl(this._firestore);

  @override
  Future<List<CommentDto>> fetchComments(String postId) async {
    final snapshot = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => CommentDto.fromJson({...doc.data(), 'commentId': doc.id}))
        .toList();
  }

  @override
  Future<void> addComment(CommentDto dto) async {
    await _firestore
        .collection('posts')
        .doc(dto.postId)
        .collection('comments')
        .add(dto.toJson());
  }

  @override
  Future<void> updateComment(
    String postId,
    String commentId,
    String content,
  ) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .update({'content': content});
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }

  @override
  Stream<List<CommentDto>> commentsStream(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    CommentDto.fromJson({...doc.data(), 'commentId': doc.id}),
              )
              .toList(),
        );
  }
}

// ...existing code...
