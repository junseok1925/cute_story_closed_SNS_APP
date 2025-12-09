import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F0),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: item(index),
            );
          },
        ),
      ),
    );
  }

Widget item(int index) {
  return Container(
    width: double.infinity,
    height: 155,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.grey[200],
    ),
    child: Stack(
      children: [
        /// ✅ 1️⃣ 배경 전체 이미지 (카드 꽉 채움)
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            "https://picsum.photos/600/400?random=$index",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.delete,
              size: 18,
              color: Colors.red,
            ),
          ),
        ),
      

      
        Positioned(
          right: 12,
          bottom: 12,
          child: Column(
            children: const [
              /// ❤️ 좋아요
              Column(
                children: [
                  Icon(Icons.thumb_up_alt_outlined, color: Colors.white),
                  SizedBox(height: 4),
                  Text(
                    "10.0k",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),

              SizedBox(height: 16),

              /// 💬 댓글
              Column(
                children: [
                  Icon(Icons.chat_bubble_outline, color: Colors.white),
                  SizedBox(height: 4),
                  Text(
                    "3.4k",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}