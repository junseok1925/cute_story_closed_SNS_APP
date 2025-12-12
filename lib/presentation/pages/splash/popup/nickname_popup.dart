import 'package:cute_story_closed_sns_app/core/theme/app_theme.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'nickname_popup_viewmodel.dart';
import '../../../../data/repository/user_repository_impl.dart';

Future<void> showNicknamePopup(
  BuildContext context, {
  required String uid,
  required String email,
  required String provider,
}) {
  final nicknameController = TextEditingController();
  final viewModel = NicknamePopupViewModel(
    userRepository: UserRepositoryImpl(),
    uid: uid,
    email: email,
    provider: provider,
  );

  Future<void> submitNickname(BuildContext context) async {
    final value = nicknameController.text.trim();
    if (value.isEmpty) return;
    await viewModel.saveNickname(value);
    if (!context.mounted) return;
    Navigator.of(context).pop();
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
  }

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Center(
              child: Container(
                width: 336,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: vrc(context).background200,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        "닉네임을 설정해주세요",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: fxc(context).brandColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: nicknameController,
                      decoration: InputDecoration(
                        hintText: "태유니 엉뜨...",
                        filled: true,
                        fillColor: vrc(context).background200,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: fxc(context).brandColor!,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: vrc(context).background200!,
                            width: 2,
                          ),
                        ),
                      ),
                      onSubmitted: (_) => submitNickname(context),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: fxc(context).brandColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => submitNickname(context),
                        child: const Text(
                          "확인",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
