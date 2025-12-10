import 'package:flutter/material.dart';

class Bottomnavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const Bottomnavbar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.photo_camera), label: '추가'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이'),
      ],
    );
  }
}

// 메인에 stateful 위젯 변경 후 추가
  // int selectedIndex = 0;

  // final pages = [PostListPage(), AddPage(), MyPage()];
// 이 페이지 임포트 필수