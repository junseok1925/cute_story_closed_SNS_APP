import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cute_story_closed_sns_app/data/data_source/storage_data_source.dart';
import 'package:cute_story_closed_sns_app/data/data_source/storage_data_source_impl.dart';
import 'package:cute_story_closed_sns_app/data/repository/storage_repository_impl.dart';
import 'package:cute_story_closed_sns_app/domain/repository/storage_repository.dart';
import 'package:cute_story_closed_sns_app/domain/usercase/toggle_like_usecase.dart';
import 'package:cute_story_closed_sns_app/domain/usercase/upload_file_usecase.dart';
import 'package:cute_story_closed_sns_app/domain/usercase/upload_post_usecase.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/add/add_post_state.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/add/add_post_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
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
import 'package:flutter_riverpod/legacy.dart';
import 'package:cute_story_closed_sns_app/data/repository/user_repository_impl.dart';
import 'package:cute_story_closed_sns_app/domain/repository/user_repository.dart';
import 'package:cute_story_closed_sns_app/domain/entity/user.dart' as domain_user;
import 'package:cute_story_closed_sns_app/presentation/pages/my_page/my_page_view_model.dart';// 시윤 작업
import 'package:cute_story_closed_sns_app/domain/entity/post.dart'; //  시윤 작업 

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl();
});

final currentUserProvider = FutureProvider<domain_user.User?>((ref) async {
  final firebaseUser = fb_auth.FirebaseAuth.instance.currentUser;
  if (firebaseUser == null) return null;
  return ref.read(userRepositoryProvider).fetchUser(firebaseUser.uid);
});

/// FirebaseAuth uid만 반환 (null-safe)
final firebaseUserIdProvider = FutureProvider<String?>((ref) async {
  return fb_auth.FirebaseAuth.instance.currentUser?.uid;
});

/// 현재 사용자 닉네임 반환 (UserRepository 조회 기반)
final currentUserNicknameProvider = FutureProvider<String?>((ref) async {
  final user = await ref.read(currentUserProvider.future);
  return user?.nickname;
});

/// 로컬에 캐시된 주소를 불러오는 프로바이더
final cachedAddressProvider = FutureProvider<String?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('cached_address');
});

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

final toggleLikeUsecaseProvider = Provider<ToggleLikeUsecase>((ref) {
  return ToggleLikeUsecase(ref.read(postRepositoryProvider));
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

final storageDataSourceProvider = Provider<StorageDataSource>((ref) {
  return StorageDataSourceImpl(FirebaseStorage.instance);
});

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  final dataSource = ref.read(storageDataSourceProvider);
  return StorageRepositoryImpl(dataSource);
});

final uploadFileUsecaseProvider = Provider<UploadFileUseCase>((ref) {
  final repo = ref.read(storageRepositoryProvider);
  return UploadFileUseCase(repo);
});

final uploadPostUseCaseProvider = Provider<UploadPostUseCase>((ref) {
  final repo = ref.watch(postRepositoryProvider);
  return UploadPostUseCase(repo);
});

final addPostViewModelProvider =
    StateNotifierProvider<AddPostViewModel, AddPostState>((ref) {
      final uploadPost = ref.watch(uploadPostUseCaseProvider);
      final uploadFile = ref.watch(uploadFileUsecaseProvider); // Storage 업로드
      return AddPostViewModel(uploadPost, uploadFile);
    });

final myPageViewModelProvider = // 시윤 MYPAGE 작업 
    StateNotifierProvider<MyPageViewModel, List<Post>>((ref) {
  final fetchPosts = ref.watch(fetchPostsUsecaseProvider);
  final postRepo = ref.watch(postRepositoryProvider);

  return MyPageViewModel(fetchPosts, postRepo);
});
