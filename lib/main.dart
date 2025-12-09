import 'package:cute_story_closed_sns_app/core/config/firebase_options.dart';
import 'package:cute_story_closed_sns_app/core/theme/app_theme.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/add/add_page.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/bottomnavbar/bottomnavbar.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/comments/comments_page.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/my_page/my_page.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/post_list/post_list_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;

  final pages = [PostListPage(), AddPage(), MyPage()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cute Story SNS',
      theme: AppTheme.light,

      // 첫 화면은 PostListPage로 설정
      // home: MyPage(),
      // home: MyPage(),
      // home: PostListPage(),
      // 바텀 내브 적용 후 (bottomnavbar.dart 파일 밑에 설명 읽고 실행)
      home: Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: Bottomnavbar(
          currentIndex: selectedIndex,
          onTap: (index) => setState(() => selectedIndex = index),
        ),
      ),
    );
  }
}
