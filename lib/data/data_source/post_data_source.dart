import 'package:cute_story_closed_sns_app/data/dto/post_dto.dart';

abstract interface class PostDataSource {
  /// 최신순으로 게시글 가져오기
  Future<List<PostDto>> fetchPosts({int limit = 10, DateTime? startAfter});

  /// 단일 게시글 가져오기
  Future<PostDto?> fetchPostById(String postId);

  /// 게시글 업로드
  Future<void> uploadPost(PostDto dto);

  /// 게시글 수정
  Future<void> updatePost(PostDto dto);

  /// 게시글 삭제
  Future<void> deletePost(String postId);

  /// 좋아요 저장 및 게시글 카운트 증가
  Future<void> addLike({
    required String postId,
    required String userId,
    required String nickname,
    required DateTime createdAt,
  });

  /// 좋아요 여부 조회
  Future<bool> isLiked({
    required String postId,
    required String userId,
  });

  /// 좋아요 취소 및 카운트 감소
  Future<void> removeLike({
    required String postId,
    required String userId,
  });
}
