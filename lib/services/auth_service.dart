import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // 현재 사용자 가져오기
  User? get currentUser => _auth.currentUser;

  // 인증 상태 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 구글 로그인
  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('Google Sign In 시작...');

      // 기존 로그인 세션 정리
      if (await _googleSignIn.isSignedIn()) {
        print('기존 로그인 세션 정리 중...');
        await _googleSignIn.signOut();
      }

      // Google Sign In 시작
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('사용자가 로그인을 취소했습니다.');
        return null;
      }

      print('Google 계정 선택됨: ${googleUser.email}');

      // Google 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print('Google 인증 토큰 획득 완료');

      // Firebase 인증 정보 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('Firebase 인증 시작...');

      // Firebase에 로그인
      final userCredential = await _auth.signInWithCredential(credential);

      print('Firebase 로그인 성공: ${userCredential.user?.email}');

      return userCredential;
    } catch (e) {
      print('구글 로그인 오류: $e');
      print('오류 타입: ${e.runtimeType}');

      // 더 자세한 오류 정보 출력
      if (e is PlatformException) {
        print('PlatformException 코드: ${e.code}');
        print('PlatformException 메시지: ${e.message}');
        print('PlatformException 세부사항: ${e.details}');
      }

      return null;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      print('로그아웃 완료');
    } catch (e) {
      print('로그아웃 오류: $e');
    }
  }

  // 사용자 정보 가져오기
  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return {
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
        };
      }
      return null;
    } catch (e) {
      print('사용자 정보 가져오기 오류: $e');
      return null;
    }
  }
}
