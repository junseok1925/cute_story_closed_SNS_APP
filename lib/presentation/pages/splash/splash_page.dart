import 'package:cute_story_closed_sns_app/core/auth/google_login_service.dart';
import 'package:cute_story_closed_sns_app/core/location_cache_manager.dart';
import 'package:cute_story_closed_sns_app/core/theme/app_theme.dart';
import 'package:cute_story_closed_sns_app/data/repository/user_repository_impl.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/home/home_page.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/splash/popup/nickname_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SplashPage extends HookWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final showLoginButton = useState(false);
    final isCheckingAuth = useState(true);

    useEffect(() {
      // 위치 권한/주소 로딩 및 스트리밍을 앱 전역 매니저에 위임
      LocationCacheManager.start();

      // 이미 로그인된 경우 프로필 확인 후 홈
      Future.microtask(() async {
        final authUser = await FirebaseAuth.instance.authStateChanges().first;
        if (authUser != null) {
          final repo = UserRepositoryImpl();
          final profile = await repo.fetchUser(authUser.uid);
          if (!context.mounted) return;
          if (profile == null || profile.nickname.trim().isEmpty) {
            await showNicknamePopup(
              context,
              uid: authUser.uid,
              email: authUser.email ?? '',
              provider: authUser.providerData.isNotEmpty
                  ? authUser.providerData.first.providerId
                  : 'google',
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
        } else {
          showLoginButton.value = true;
        }
        isCheckingAuth.value = false;
      });

      return null;
    }, []);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: fxc(context).secondColor,
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
                opacity: showLoginButton.value && !isCheckingAuth.value ? 1 : 0,
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
                        final repo = UserRepositoryImpl();
                        final profile = await repo.fetchUser(user.uid);
                        if (!context.mounted) return;
                        if (profile == null ||
                            profile.nickname.trim().isEmpty) {
                          await showNicknamePopup(
                            context,
                            uid: user.uid,
                            email: user.email ?? '',
                            provider: 'google',
                          );
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        }
                      },
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
