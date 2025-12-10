import 'dart:io';
import 'package:cute_story_closed_sns_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class MediaPickerBox extends StatelessWidget {
  final XFile? pickedFile;
  final VideoPlayerController? controller;
  final VoidCallback onTapImage;
  final VoidCallback onLongPressVideo;

  const MediaPickerBox({
    super.key,
    required this.pickedFile,
    required this.controller,
    required this.onTapImage,
    required this.onLongPressVideo,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapImage,
      onLongPress: onLongPressVideo,
      child: Container(
        width: double.infinity,
        height: 550,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: vrc(context).background200,
        ),
        child: _buildPreview(context),
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    if (pickedFile == null) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.camera_alt_rounded,
            size: 270,
            color: fxc(context).brandColor,
          ),
          const Positioned(
            bottom: 40,
            child: Text(
              "업로드할 이미지를 선택하려면 화면을 한 번 탭하세요.\n동영상을 올리고 싶다면 길게 눌러 선택할 수 있어요.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }

    if (controller != null && controller!.value.isInitialized) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: controller!.value.aspectRatio,
          child: VideoPlayer(controller!),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.file(
        File(pickedFile!.path),
        fit: BoxFit.cover,
      ),
    );
  }
}
