import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 디버깅을 위한 로그 추가
        print('AuthWrapper - ConnectionState: ${snapshot.connectionState}');
        print('AuthWrapper - HasData: ${snapshot.hasData}');
        print('AuthWrapper - User: ${snapshot.data}');
        print('AuthWrapper - User UID: ${snapshot.data?.uid}');
        print('AuthWrapper - User Email: ${snapshot.data?.email}');

        if (snapshot.connectionState == ConnectionState.waiting) {
          print('AuthWrapper - 로딩 화면 표시');
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Firebase 초기화 중...'),
                ],
              ),
            ),
          );
        }

        // 사용자가 로그인된 경우
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.uid.isNotEmpty) {
          print('AuthWrapper - 사용자 로그인됨: ${snapshot.data!.email}');
          print('AuthWrapper - HomeScreen으로 전환');
          return const HomeScreen();
        } else {
          // 사용자가 로그인되지 않은 경우
          print('AuthWrapper - 로그인 화면 표시');
          return const LoginScreen();
        }
      },
    );
  }
}
