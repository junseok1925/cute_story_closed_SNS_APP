import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 구글 로그인 창
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .authenticate();
      if (googleUser == null) return null; // 로그인 취소

      // 구글 인증 정보
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase 인증 정보 생성
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Firebase에 로그인
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // 에러 발생 시 null 반환 (원하면 rethrow 또는 로그 처리)
      return null;
    }
  }
}
