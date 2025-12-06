import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cute_story_closed_sns_app/data/data_source/post_data_source.dart';
import 'package:cute_story_closed_sns_app/data/data_source/post_data_source_impl.dart';
import 'package:cute_story_closed_sns_app/data/repository/post_repository_impl.dart';
import 'package:cute_story_closed_sns_app/domain/repository/post_repository.dart';
import 'package:cute_story_closed_sns_app/domain/usercase/fetch_posts_usercase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ------------------------------
/// DataSource Provider
/// ------------------------------
final postDataSourceProvider = Provider<PostDataSource>((ref) {
  return PostDataSourceImpl(FirebaseFirestore.instance);
});

/// ------------------------------
/// Repository Provider
/// ------------------------------
final postRepositoryProvider = Provider<PostRepository>((ref) {
  final dataSource = ref.read(postDataSourceProvider);
  return PostRepositoryImpl(dataSource);
});

/// ------------------------------
/// UseCase Provider
/// ------------------------------
final fetchPostsUsecaseProvider = Provider<FetchPostsUsecase>((ref) {
  final repo = ref.read(postRepositoryProvider);
  return FetchPostsUsecase(repo);
});
