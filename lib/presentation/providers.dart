
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cute_story_closed_sns_app/data/data_source/post_data_source.dart';
import 'package:cute_story_closed_sns_app/data/data_source/post_data_source_impl.dart';
import 'package:cute_story_closed_sns_app/data/repository/post_repository_impl.dart';
import 'package:cute_story_closed_sns_app/domain/repository/post_repository.dart';
import 'package:cute_story_closed_sns_app/domain/usercase/fetch_posts_usercase.dart';
import 'package:cute_story_closed_sns_app/data/data_source/comment_data_source.dart';
import 'package:cute_story_closed_sns_app/data/data_source/comment_data_source_impl.dart';
import 'package:cute_story_closed_sns_app/data/repository/comment_repository_impl.dart';
import 'package:cute_story_closed_sns_app/domain/repository/comment_repository.dart';
import 'package:cute_story_closed_sns_app/domain/usercase/comment_usecases.dart';
import 'package:cute_story_closed_sns_app/domain/usercase/comment_update_delete_usecases.dart';

final updateCommentUsecaseProvider = Provider<UpdateCommentUsecase>((ref) {
  final repo = ref.read(commentRepositoryProvider);
  return UpdateCommentUsecase(repo);
});

final deleteCommentUsecaseProvider = Provider<DeleteCommentUsecase>((ref) {
  final repo = ref.read(commentRepositoryProvider);
  return DeleteCommentUsecase(repo);
});

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

/// ------------------------------
/// Comment Providers
/// ------------------------------
final commentDataSourceProvider = Provider<CommentDataSource>((ref) {
  return CommentDataSourceImpl(FirebaseFirestore.instance);
});

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  final dataSource = ref.read(commentDataSourceProvider);
  return CommentRepositoryImpl(dataSource);
});

final fetchCommentsUsecaseProvider = Provider<FetchCommentsUsecase>((ref) {
  final repo = ref.read(commentRepositoryProvider);
  return FetchCommentsUsecase(repo);
});

final addCommentUsecaseProvider = Provider<AddCommentUsecase>((ref) {
  final repo = ref.read(commentRepositoryProvider);
  return AddCommentUsecase(repo);
});
