class Comment {
  final String? commentId;
  final String postId;
  final String userId;
  final String nickname;
  final String content;
  final DateTime createdAt;

  const Comment({
    this.commentId,
    required this.postId,
    required this.userId,
    required this.nickname,
    required this.content,
    required this.createdAt,
  });
}
