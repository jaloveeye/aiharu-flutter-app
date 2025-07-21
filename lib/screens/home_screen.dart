import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    print('HomeScreen - 초기화됨');
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      print('HomeScreen - 사용자 정보 로드 시작');
      final userInfo = await _authService.getUserInfo();
      print('HomeScreen - 사용자 정보 로드 완료: $userInfo');
      if (mounted) {
        setState(() {
          _userInfo = userInfo;
        });
        print('HomeScreen - 상태 업데이트 완료');
      }
    } catch (e) {
      print('HomeScreen - 사용자 정보 로드 오류: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그아웃 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI하루',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[600],
        actions: [
          // 명확한 로그아웃 버튼 추가
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: '로그아웃',
          ),
          // 사용자 프로필 메뉴 (선택사항)
          if (_userInfo != null)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'profile') {
                  // 프로필 정보 표시
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${_userInfo!['displayName']}님의 프로필'),
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('프로필'),
                    ],
                  ),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: _userInfo?['photoURL'] != null
                      ? NetworkImage(_userInfo!['photoURL'])
                      : null,
                  child: _userInfo?['photoURL'] == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사용자 환영 메시지
            if (_userInfo != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: _userInfo!['photoURL'] != null
                            ? NetworkImage(_userInfo!['photoURL'])
                            : null,
                        child: _userInfo!['photoURL'] == null
                            ? const Icon(Icons.person, size: 30)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '안녕하세요, ${_userInfo!['displayName'] ?? '사용자'}님!',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _userInfo!['email'] ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // 메인 기능 카드들
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    icon: Icons.camera_alt,
                    title: '사진 촬영',
                    subtitle: '식단 사진을 찍어보세요',
                    color: Colors.blue,
                    onTap: () {
                      // 사진 촬영 기능 구현
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('사진 촬영 기능이 곧 추가됩니다!')),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.photo_library,
                    title: '갤러리',
                    subtitle: '기존 사진을 선택하세요',
                    color: Colors.green,
                    onTap: () {
                      // 갤러리 기능 구현
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('갤러리 기능이 곧 추가됩니다!')),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.analytics,
                    title: '분석 결과',
                    subtitle: '이전 분석 결과를 확인하세요',
                    color: Colors.orange,
                    onTap: () {
                      // 분석 결과 기능 구현
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('분석 결과 기능이 곧 추가됩니다!')),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.settings,
                    title: '설정',
                    subtitle: '앱 설정을 변경하세요',
                    color: Colors.purple,
                    onTap: () {
                      // 설정 기능 구현
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('설정 기능이 곧 추가됩니다!')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
