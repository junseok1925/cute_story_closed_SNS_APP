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
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 27,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera), label: '추가'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이'),
        ],
      ),
    );
  }
}
