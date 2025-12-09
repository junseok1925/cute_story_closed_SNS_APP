import 'package:cloud_firestore/cloud_firestore.dart';

class CommentDto {
  final String? commentId;
  final String postId;
  final String userId;
  final String nickname;
  final String content;
  final Timestamp createdAt;

  const CommentDto({
    this.commentId,
    required this.postId,
    required this.userId,
    required this.nickname,
    required this.content,
    required this.createdAt,
  });

  factory CommentDto.fromJson(Map<String, dynamic> map) {
    return CommentDto(
      commentId: map['commentId'],
      postId: map['postId'],
      userId: map['userId'],
      nickname: map['nickname'],
      content: map['content'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'postId': postId,
      'userId': userId,
      'nickname': nickname,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
