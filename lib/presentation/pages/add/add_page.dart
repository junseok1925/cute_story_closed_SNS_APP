import 'dart:io';
import 'package:cute_story_closed_sns_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import 'widgets/media_picker_box.dart';
import 'widgets/cs_text_field.dart';
import 'widgets/cs_button.dart';

class AddPage extends HookWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();
    final tagController = useTextEditingController();

    final pickedFile = useState<XFile?>(null);
    final videoController = useState<VideoPlayerController?>(null);

    Future<void> pickImage() async {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery);

      if (file != null) {
        pickedFile.value = file;
        videoController.value?.dispose();
        videoController.value = null;
      }
    }

    Future<void> pickVideo() async {
      final picker = ImagePicker();
      final file = await picker.pickVideo(source: ImageSource.gallery);

      if (file != null) {
        pickedFile.value = file;

        final controller = VideoPlayerController.file(File(file.path));
        await controller.initialize();
        controller.setLooping(true);
        controller.play();
        videoController.value = controller;
      }
    }

    return Scaffold(
      backgroundColor: vrc(context).background100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Column(
              children: [
                MediaPickerBox(
                  pickedFile: pickedFile.value,
                  controller: videoController.value,
                  onTapImage: pickImage,
                  onLongPressVideo: pickVideo,
                ),

                const SizedBox(height: 15),

                CsTextField(
                  context: context,
                  controller: titleController,
                  hint: "내용을 입력해주세요",
                ),

                const SizedBox(height: 15),

                CsTextField(
                  context: context,
                  controller: tagController,
                  hint: "태그를 입력해주세요",
                ),

                const SizedBox(height: 25),

                Row(
                  children: [
                    Expanded(child: CsButton(context: context, text: "취소")),
                    const SizedBox(width: 10),
                    Expanded(child: CsButton(context: context, text: "게시")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
