import 'package:cute_story_closed_sns_app/domain/entity/post.dart';

/// 도메인 레이어의 Repository 인터페이스.
/// 앱의 모든 기능은 이 인터페이스만 바라보고 동작함.
/// (Firebase, REST API 등 실제 데이터 출처는 DataLayer에서 구현)
abstract interface class PostRepository {
  /// 최신순 게시물 목록 조회 (무한스크롤 대비 limit & startAfter)
  Future<List<Post>> fetchPosts({int limit, DateTime? startAfter});

  /// 특정 게시물 단일 조회
  Future<Post?> fetchPostById(String postId);

  /// 게시물 업로드
  Future<void> uploadPost(Post post);

  /// 게시물 수정
  Future<void> updatePost(Post post);

  /// 게시물 삭제
  Future<void> deletePost(String postId);
}
