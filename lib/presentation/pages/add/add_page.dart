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
    final addState = ref.watch(addPostViewModelProvider);
    // AddPage 진입 시 상태를 초기화하지 않음. (게시 성공/취소 시에만 초기화)

    // 업로드 성공 시 네비게이션은 onPressed에서만 처리
    final titleController = useTextEditingController(text: addState.content);
    final tagController = useTextEditingController(text: addState.tag);

    final state = ref.watch(addPostViewModelProvider);

    useEffect(() {
      titleController.text = state.content;
      tagController.text = state.tag;
      return null;
    }, [state.content, state.tag]);
    final viewModel = ref.read(addPostViewModelProvider.notifier);
    final currentUserAsync = ref.watch(currentUserProvider);
    final cachedAddressAsync = ref.watch(cachedAddressProvider);

    return Scaffold(
      backgroundColor: vrc(context).background100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
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
                  onChanged: (value) => ref
                      .read(addPostViewModelProvider.notifier)
                      .updateContent(value),
                ),

                const SizedBox(height: 15),

                CsTextField(
                  context: context,
                  controller: tagController,
                  hint: "태그를 입력해주세요",
                  onChanged: (value) => ref
                      .read(addPostViewModelProvider.notifier)
                      .updateTag(value),
                ),

                const SizedBox(height: 15),

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
                        onPressed: () {
                          ref.read(addPostViewModelProvider.notifier).reset();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const HomePage(initialIndex: 0),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CsButton(
                        context: context,
                        text: state.isLoading || currentUserAsync.isLoading
                            ? "게시 중..."
                            : "게시",
                        onPressed:
                            state.isLoading ||
                                currentUserAsync.isLoading ||
                                cachedAddressAsync.isLoading
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
                                final location = cachedAddressAsync.value;
                                if (location == null || location.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("위치 정보를 불러오지 못했습니다."),
                                    ),
                                  );
                                  return;
                                }
                                await viewModel.uploadPost(
                                  content: titleController.text,
                                  authorId: user.id,
                                  nickname: user.nickname,
                                  location: location,
                                );

                                // 업로드 후 최신 상태를 다시 읽어서 체크
                                final newState = ref.read(
                                  addPostViewModelProvider,
                                );
                                if (newState.error == null && context.mounted) {
                                  viewModel.reset();
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
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
