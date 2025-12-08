class Like {
  final String postId;
  final String userId;
  final String nickname;
  final DateTime createdAt;

  const Like({
    required this.postId,
    required this.userId,
    required this.nickname,
    required this.createdAt,
  });

  Like copyWith({
    String? postId,
    String? userId,
    String? nickname,
    DateTime? createdAt,
  }) {
    return Like(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
