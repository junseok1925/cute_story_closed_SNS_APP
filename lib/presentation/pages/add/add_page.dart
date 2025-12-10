import 'package:cute_story_closed_sns_app/core/theme/app_theme.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/home/home_page.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/post_list/post_list_view_model.dart';
import 'package:cute_story_closed_sns_app/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/media_picker_box.dart';
import 'widgets/cs_text_field.dart';
import 'widgets/cs_button.dart';

class AddPage extends HookConsumerWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final tagController = useTextEditingController();

    final state = ref.watch(addPostViewModelProvider);
    final viewModel = ref.read(addPostViewModelProvider.notifier);
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: vrc(context).background100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Column(
              children: [
                MediaPickerBox(
                  pickedFile: state.pickedFile,
                  controller: state.videoController,
                  onTapImage: () => viewModel.pickImage(),
                  onLongPressVideo: () => viewModel.pickVideo(),
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

                const SizedBox(height: 20),

                if (state.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      state.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                Row(
                  children: [
                    Expanded(
                      child: CsButton(
                        context: context,
                        text: "취소",
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CsButton(
                        context: context,
                        text: state.isLoading || currentUserAsync.isLoading
                            ? "게시 중..."
                            : "게시",
                        onPressed: state.isLoading || currentUserAsync.isLoading
                            ? null
                            : () async {
                                final user = currentUserAsync.value;
                                if (user == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("로그인 정보를 불러오지 못했습니다."),
                                    ),
                                  );
                                  return;
                                }
                                await viewModel.uploadPost(
                                  content: titleController.text,
                                  authorId: user.id,
                                  nickname: user.nickname,
                                );

                                if (state.error == null && context.mounted) {
                                  // 새 게시글을 쓰면 post_list에 바로 보이게 함 크크루빙빙봉
                                  ref.invalidate(postListViewModelProvider);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const HomePage(initialIndex: 0),
                                    ),
                                  );
                                }
                              },
                      ),
                    ),
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
