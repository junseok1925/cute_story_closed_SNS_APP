import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cute_story_closed_sns_app/data/data_source/like_data_source.dart';
import 'package:cute_story_closed_sns_app/data/data_source/like_data_source_impl.dart';
import 'package:cute_story_closed_sns_app/data/data_source/post_data_source.dart';
import 'package:cute_story_closed_sns_app/data/data_source/post_data_source_impl.dart';
import 'package:cute_story_closed_sns_app/data/repository/like_repository_impl.dart';
import 'package:cute_story_closed_sns_app/data/repository/post_repository_impl.dart';
import 'package:cute_story_closed_sns_app/domain/repository/like_repository.dart';
import 'package:cute_story_closed_sns_app/domain/repository/post_repository.dart';
import 'package:cute_story_closed_sns_app/domain/usercase/fetch_posts_usercase.dart';
import 'package:cute_story_closed_sns_app/domain/usercase/toggle_like_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ------------------------------
/// Post DataSource Provider
/// ------------------------------
final postDataSourceProvider = Provider<PostDataSource>((ref) {
  return PostDataSourceImpl(FirebaseFirestore.instance);
});

/// ------------------------------
/// Post Repository Provider
/// ------------------------------
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepositoryImpl(ref.read(postDataSourceProvider));
});

/// ------------------------------
/// FetchPosts UseCase Provider
/// ------------------------------
final fetchPostsUsecaseProvider = Provider<FetchPostsUsecase>((ref) {
  return FetchPostsUsecase(ref.read(postRepositoryProvider));
});

/// ------------------------------
/// Like DataSource Provider
/// ------------------------------
final likeDataSourceProvider = Provider<LikeDataSource>((ref) {
  return LikeDataSourceImpl();
});

/// ------------------------------
/// Like Repository Provider
/// ------------------------------
final likeRepositoryProvider = Provider<LikeRepository>((ref) {
  return LikeRepositoryImpl(ref.read(likeDataSourceProvider));
});

/// ------------------------------
/// ToggleLike UseCase Provider
/// ------------------------------
final toggleLikeUsecaseProvider = Provider<ToggleLikeUsecase>((ref) {
  return ToggleLikeUsecase(ref.read(likeRepositoryProvider));
});
