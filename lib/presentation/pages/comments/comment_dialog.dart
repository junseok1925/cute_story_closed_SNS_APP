import 'package:flutter/material.dart';

Future<String?> showEditCommentDialog(
  BuildContext context,
  String initial,
) async {
  final controller = TextEditingController(text: initial);
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final textColor = isDark ? Colors.white : Colors.black;
  return await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('댓글 수정', style: TextStyle(color: textColor)),
      content: TextField(
        controller: controller,
        autofocus: true,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: '댓글을 입력하세요',
          hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: textColor.withOpacity(0.3)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: textColor),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text('취소', style: TextStyle(color: textColor)),
          onPressed: () => Navigator.of(ctx).pop(),
        ),
        TextButton(
          child: Text(
            '저장',
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
        ),
      ],
    ),
  );
}

Future<bool?> showDeleteCommentDialog(BuildContext context) async {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final textColor = isDark ? Colors.white : Colors.black;
  return await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('댓글 삭제', style: TextStyle(color: textColor)),
      content: Text('정말 삭제하시겠습니까?', style: TextStyle(color: textColor)),
      actions: [
        TextButton(
          child: Text('취소', style: TextStyle(color: textColor)),
          onPressed: () => Navigator.of(ctx).pop(false),
        ),
        TextButton(
          child: Text(
            '삭제',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => Navigator.of(ctx).pop(true),
        ),
      ],
    ),
  );
}
