import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cute_story_closed_sns_app/data/data_source/like_data_source.dart';
import 'package:cute_story_closed_sns_app/data/data_source/like_data_source_impl.dart';
import 'package:cute_story_closed_sns_app/domain/usercase/toggle_like_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cute_story_closed_sns_app/data/data_source/post_data_source.dart';
import 'package:cute_story_closed_sns_app/data/data_source/post_data_source_impl.dart';
import 'package:cute_story_closed_sns_app/data/repository/like_repository_impl.dart';
import 'package:cute_story_closed_sns_app/data/repository/post_repository_impl.dart';
import 'package:cute_story_closed_sns_app/domain/repository/like_repository.dart';
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

final postDataSourceProvider = Provider<PostDataSource>((ref) {
  return PostDataSourceImpl(FirebaseFirestore.instance);
});

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepositoryImpl(ref.read(postDataSourceProvider));
});

final fetchPostsUsecaseProvider = Provider<FetchPostsUsecase>((ref) {
  return FetchPostsUsecase(ref.read(postRepositoryProvider));
});

final likeDataSourceProvider = Provider<LikeDataSource>((ref) {
  return LikeDataSourceImpl();
});

final likeRepositoryProvider = Provider<LikeRepository>((ref) {
  return LikeRepositoryImpl(ref.read(likeDataSourceProvider));
});

final toggleLikeUsecaseProvider = Provider<ToggleLikeUsecase>((ref) {
  return ToggleLikeUsecase(ref.read(likeRepositoryProvider));
});

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
