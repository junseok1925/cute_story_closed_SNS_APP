import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cute_story_closed_sns_app/domain/entity/comment.dart';
import 'package:cute_story_closed_sns_app/presentation/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class CommentsViewModel {
  final Ref ref;
  final String postId;
  CommentsViewModel(this.ref, this.postId);

  AsyncValue<List<Comment>> get commentsAsync =>
      ref.watch(commentsStreamProvider(postId));
  bool get isLoading => _isLoading;
  bool _isLoading = false;

  String get _currentUserId =>
      fb_auth.FirebaseAuth.instance.currentUser?.uid ?? '';

  bool isMine(Comment c) => c.userId == _currentUserId;

  Future<void> addComment(String text) async {
    if (text.isEmpty || isLoading) return;
    _isLoading = true;
    try {
      final user = await ref.read(currentUserProvider.future);
      if (user == null) return;

      final comment = Comment(
        postId: postId,
        userId: user.id,
        nickname: user.nickname,
        content: text,
        createdAt: DateTime.now(),
      );
      await ref.read(addCommentUsecaseProvider).execute(comment);
    } finally {
      _isLoading = false;
    }
  }

  Future<void> updateComment(Comment c, String newContent) async {
    await ref
        .read(updateCommentUsecaseProvider)
        .execute(c.postId, c.commentId ?? '', newContent);
  }

  Future<void> deleteComment(Comment c) async {
    await ref
        .read(deleteCommentUsecaseProvider)
        .execute(c.postId, c.commentId ?? '');
  }
}

final commentsViewModelProvider = Provider.family<CommentsViewModel, String>((
  ref,
  postId,
) {
  return CommentsViewModel(ref, postId);
});

final commentsStreamProvider = StreamProvider.family<List<Comment>, String>((
  ref,
  postId,
) {
  final repo = ref.read(commentRepositoryProvider);
  return repo
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
                createdAt: dto.createdAt is Timestamp
                    ? (dto.createdAt as Timestamp).toDate()
                    : dto.createdAt,
              ),
            )
            .toList(),
      );
});
