import 'package:cloud_firestore/cloud_firestore.dart';

class PostDto {
  
  final String postId;
  final String mediaUrl;
  final String mediaType;
  final String content;
  final Timestamp createdAt; // Firestore Timestamp
  final String authorId;
  final String nickname;
  final int likeCount;
  final int commentCount;

  const PostDto({
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

  /// Firestore → DTO (map only)
  PostDto.fromJson(Map<String, dynamic> map)
      : this(
          postId: map['postId'],
          mediaUrl: map['mediaUrl'],
          mediaType: map['mediaType'],
          content: map['content'],
          createdAt: map['createdAt'],
          authorId: map['authorId'],
          nickname: map['nickname'],
          likeCount: (map['likeCount'] ?? 0),
          commentCount: (map['commentCount'] ?? 0),
        );

  /// Firestore → DTO (DocumentSnapshot 기반, doc.id 우선)
  factory PostDto.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return PostDto(
      // Firestore doc.id를 항상 우선 사용해 업데이트/좋아요 시 문서 불일치 문제를 방지
      postId: doc.id,
      mediaUrl: data['mediaUrl'],
      mediaType: data['mediaType'],
      content: data['content'],
      createdAt: data['createdAt'],
      authorId: data['authorId'],
      nickname: data['nickname'],
      likeCount: (data['likeCount'] ?? 0),
      commentCount: (data['commentCount'] ?? 0),
    );
  }

  /// DTO → Firestore 저장 형식
  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'content': content,
      'createdAt': createdAt,
      'authorId': authorId,
      'nickname': nickname,
      'likeCount': likeCount,
      'commentCount': commentCount,
    };
  }
}
