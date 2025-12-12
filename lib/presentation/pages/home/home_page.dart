import 'package:cute_story_closed_sns_app/presentation/pages/add/add_page.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/bottomnavbar/bottomnavbar.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/my_page/my_page.dart';

import 'package:cute_story_closed_sns_app/presentation/pages/post_list/post_list_page.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int selectedIndex;

  final pages = [PostListPage(), AddPage(), MyPage()];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: Bottomnavbar(
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
      ),
    );
  }
}
