import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cute_story_closed_sns_app/data/data_source/post_data_source.dart';
import 'package:cute_story_closed_sns_app/data/dto/post_dto.dart';
import 'package:cute_story_closed_sns_app/domain/entity/post.dart';
import 'package:cute_story_closed_sns_app/domain/repository/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl(this._postDataSource);

  final PostDataSource _postDataSource;

  @override
  Future<List<Post>> fetchPosts({
    int limit = 10,
    DateTime? startAfter,
    String? location,
  }) async {
    // DataSource에서 받아온 것은 PostDto 리스트
    final dtoList = await _postDataSource.fetchPosts(
      limit: limit,
      startAfter: startAfter,
      location: location,
    );

    // DTO → Entity 변환
    return dtoList
        .map(
          (dto) => Post(
            postId: dto.postId,
            authorId: dto.authorId,
            nickname: dto.nickname,
            mediaUrl: dto.mediaUrl,
            mediaType: dto.mediaType,
            content: dto.content,
            location: dto.location,
            likeCount: dto.likeCount,
            commentCount: dto.commentCount,
            createdAt: dto.createdAt.toDate(),
            likedByMe: false,
          ),
        )
        .toList();
  }

  @override
  Future<Post?> fetchPostById(String postId) async {
    final dto = await _postDataSource.fetchPostById(postId);

    if (dto == null) return null;

    return Post(
      postId: dto.postId,
      authorId: dto.authorId,
      nickname: dto.nickname,
      mediaUrl: dto.mediaUrl,
      mediaType: dto.mediaType,
      content: dto.content,
      location: dto.location,
      likeCount: dto.likeCount,
      commentCount: dto.commentCount,
      createdAt: dto.createdAt.toDate(),
      likedByMe: false,
    );
  }

  @override
  Future<void> uploadPost(Post post) async {
    final dto = PostDto(
      postId: post.postId,
      authorId: post.authorId,
      nickname: post.nickname,
      mediaUrl: post.mediaUrl,
      mediaType: post.mediaType,
      content: post.content,
      location: post.location,
      likeCount: post.likeCount,
      commentCount: post.commentCount,
      createdAt: Timestamp.fromDate(post.createdAt),
    );

    await _postDataSource.uploadPost(dto);
  }

  @override
  Future<void> updatePost(Post post) async {
    final dto = PostDto(
      postId: post.postId,
      authorId: post.authorId,
      nickname: post.nickname,
      mediaUrl: post.mediaUrl,
      mediaType: post.mediaType,
      content: post.content,
      location: post.location,
      likeCount: post.likeCount,
      commentCount: post.commentCount,
      createdAt: Timestamp.fromDate(post.createdAt),
    );

    await _postDataSource.updatePost(dto);
  }

  @override
  Future<void> deletePost(String postId) async {
    await _postDataSource.deletePost(postId);
  }

  @override
  Future<bool> isLiked({
    required String postId,
    required String userId,
  }) {
    return _postDataSource.isLiked(postId: postId, userId: userId);
  }

  @override
  Future<void> addLike({
    required String postId,
    required String userId,
    required String nickname,
    required DateTime createdAt,
  }) {
    return _postDataSource.addLike(
      postId: postId,
      userId: userId,
      nickname: nickname,
      createdAt: createdAt,
    );
  }

  @override
  Future<void> removeLike({
    required String postId,
    required String userId,
  }) {
    return _postDataSource.removeLike(postId: postId, userId: userId);
  }
}
