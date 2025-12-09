import 'package:cute_story_closed_sns_app/core/auth/google_login_service.dart';
import 'package:cute_story_closed_sns_app/core/theme/app_theme.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/splash/popup/nickname_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SplashPage extends HookWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final showLoginButton = useState(false);

    useEffect(() {
      Future.delayed(Duration(seconds: 2), () {
        showLoginButton.value = true;
      });
      return null;
    }, []);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: vrc(context).background100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Image.asset("assets/images/logo.webp"),
              Spacer(),
              AnimatedOpacity(
                opacity: showLoginButton.value ? 1 : 0,
                duration: Duration(milliseconds: 800),
                child: Column(
                  children: [
                    button(
                      context,
                      color: Colors.white,
                      icon: Icons.language,
                      text: "구글로 로그인하기",
                      onTap: () async {
                        final userCredential = await GoogleLoginService()
                            .signInWithGoogle();
                        final user = userCredential?.user;
                        if (user == null) return;
                        await showNicknamePopup(
                          context,
                          uid: user.uid,
                          email: user.email ?? '',
                          provider: 'google',
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    button(
                      context,
                      color: Colors.amber,
                      icon: Icons.chat_rounded,
                      text: "카카오로 로그인하기",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget button(
    BuildContext context, {
    required Color color,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 25, color: Colors.black),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
