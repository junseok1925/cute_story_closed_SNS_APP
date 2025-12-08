class Post {
  final String postId; // Firestore 문서 ID 또는 postId 필드
  final String mediaUrl; // 이미지/비디오 URL
  final String mediaType; // "image" | "video"
  final String content; // 게시물 텍스트
  final DateTime createdAt; // Timestamp → DateTime 변환
  final String authorId; // 작성자 UID
  final String nickname; // 작성자 닉네임
  final int likeCount; // 좋아요 수
  final int commentCount; // 댓글 수

  const Post({
    required this.postId,
    required this.mediaUrl,
    required this.mediaType,
    required this.content,
    required this.createdAt,
    required this.authorId,
    required this.nickname,
    required this.likeCount,
    required this.commentCount,
  });

  Post copyWith({int? likeCount, int? commentCount}) {
    return Post(
      postId: postId,
      authorId: authorId,
      nickname: nickname,
      mediaUrl: mediaUrl,
      mediaType: mediaType,
      content: content,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt,
    );
  }
}
