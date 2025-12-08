import 'package:cloud_firestore/cloud_firestore.dart';

class LikeDto {
  final String postId;
  final String userId;
  final String nickname;
  final Timestamp createdAt;

  const LikeDto({
    required this.postId,
    required this.userId,
    required this.nickname,
    required this.createdAt,
  });

  factory LikeDto.fromJson(Map<String, dynamic> json) {
    return LikeDto(
      postId: json['postId'],
      userId: json['userId'],
      nickname: json['nickname'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'userId': userId,
      'nickname': nickname,
      'createdAt': createdAt,
    };
  }
}
