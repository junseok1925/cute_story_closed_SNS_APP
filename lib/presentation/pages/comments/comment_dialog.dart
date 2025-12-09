import 'package:flutter/material.dart';

Future<String?> showEditCommentDialog(
  BuildContext context,
  String initial,
) async {
  final controller = TextEditingController(text: initial);
  return await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('댓글 수정'),
      content: TextField(controller: controller, autofocus: true),
      actions: [
        TextButton(child: Text('취소'), onPressed: () => Navigator.of(ctx).pop()),
        TextButton(
          child: Text('저장'),
          onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
        ),
      ],
    ),
  );
}

Future<bool?> showDeleteCommentDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('댓글 삭제'),
      content: Text('정말 삭제하시겠습니까?'),
      actions: [
        TextButton(
          child: Text('취소'),
          onPressed: () => Navigator.of(ctx).pop(false),
        ),
        TextButton(
          child: Text('삭제'),
          onPressed: () => Navigator.of(ctx).pop(true),
        ),
      ],
    ),
  );
}
