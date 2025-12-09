import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

part 'add_post_state.freezed.dart';

@freezed
abstract class AddPostState with _$AddPostState {
  const factory AddPostState({
    XFile? pickedFile,
    VideoPlayerController? videoController,
    @Default(false) bool isLoading,
    String? error,
  }) = _AddPostState;
}
