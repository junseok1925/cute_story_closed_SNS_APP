import 'dart:io';
import 'package:cute_story_closed_sns_app/domain/entity/post.dart';
import 'package:cute_story_closed_sns_app/domain/usercase/upload_file_usecase.dart';
import 'package:cute_story_closed_sns_app/domain/usercase/upload_post_usecase.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/add/add_post_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class AddPostViewModel extends StateNotifier<AddPostState> {
  final TextEditingController contentController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  void setError(String error) {
    state = state.copyWith(error: error);
  }

  // 텍스트필드 값 변경 핸들러
  void updateContent(String value) {
    state = state.copyWith(content: value);
  }

  void updateTag(String value) {
    state = state.copyWith(tag: value);
  }

  AddPostViewModel(this._uploadPost, this._uploadFile)
    : super(const AddPostState());

  final UploadPostUseCase _uploadPost;
  final UploadFileUseCase _uploadFile;
  final picker = ImagePicker();

  void reset() {
    state.videoController?.dispose();
    contentController.clear();
    tagController.clear();
    state = const AddPostState();
  }

  // 이미지 선택
  Future<void> pickImage() async {
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    state.videoController?.dispose();

    state = state.copyWith(pickedFile: file, videoController: null);
  }

  // 비디오 선택
  Future<void> pickVideo() async {
    final file = await picker.pickVideo(source: ImageSource.gallery);
    if (file == null) return;

    final controller = VideoPlayerController.file(File(file.path));
    await controller.initialize();
    controller.setLooping(true);
    controller.play();

    state = state.copyWith(pickedFile: file, videoController: controller);
  }

  // 업로드
  Future<void> uploadPost({
    required String authorId,
    required String nickname,
    required String location,
  }) async {
    final content = contentController.text;
    if (state.pickedFile == null) {
      state = state.copyWith(error: "이미지 또는 동영상을 선택해주세요");
      return;
    }

    if (content.trim().isEmpty) {
      state = state.copyWith(error: "내용을 입력해주세요");
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

      // 성공 후 상태를 완전히 초기화 (에러 메시지 없이)
      state.videoController?.dispose();
      contentController.clear();
      tagController.clear();
      state = const AddPostState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

//rnldudns wnstjrdlgudsla
