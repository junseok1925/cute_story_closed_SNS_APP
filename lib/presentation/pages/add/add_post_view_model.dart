import 'dart:io';
import 'package:cute_story_closed_sns_app/domain/entity/post.dart';
import 'package:cute_story_closed_sns_app/domain/usercase/upload_file_usecase.dart';
import 'package:cute_story_closed_sns_app/domain/usercase/upload_post_usecase.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/add/add_post_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class AddPostViewModel extends StateNotifier<AddPostState> {
  AddPostViewModel(this._uploadPost, this._uploadFile) : super(const AddPostState());

  final UploadPostUseCase _uploadPost;
  final UploadFileUseCase _uploadFile;
  final picker = ImagePicker();

  void reset() {
    state.videoController?.dispose();
    state = const AddPostState();
  }

  // 이미지 선택
  Future<void> pickImage() async {
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    state.videoController?.dispose();

    state = state.copyWith(
      pickedFile: file,
      videoController: null,
    );
  }

  // 비디오 선택
  Future<void> pickVideo() async {
    final file = await picker.pickVideo(source: ImageSource.gallery);
    if (file == null) return;

    final controller = VideoPlayerController.file(File(file.path));
    await controller.initialize();
    controller.setLooping(true);
    controller.play();

    state = state.copyWith(
      pickedFile: file,
      videoController: controller,
    );
  }

  // 업로드
  Future<void> uploadPost({
    required String content,
    required String authorId,
    required String nickname,
    required String location,
  }) async {
    if (state.pickedFile == null) {
      state = state.copyWith(error: "이미지 또는 동영상을 선택해주세요");
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      // 1) 파일 Firebase Storage 업로드
      final file = File(state.pickedFile!.path);
      final mediaUrl = await _uploadFile(
        file,
        "posts/${DateTime.now().millisecondsSinceEpoch}",
      );

      // 2) Post 객체 생성
      final post = Post(
        postId: DateTime.now().millisecondsSinceEpoch.toString(),
        mediaUrl: mediaUrl,
        mediaType: state.videoController == null ? "image" : "video",
        content: content,
        createdAt: DateTime.now(),
        authorId: authorId,
        nickname: nickname,
        location: location,
        likeCount: 0,
        commentCount: 0,
      );

      // 3) Firestore 업로드
      await _uploadPost(post);

      reset();

    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
//rnldudns wnstjrdlgudsla
