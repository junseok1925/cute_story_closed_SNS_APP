import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  final dynamic comment;
  final bool isMine;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CommentItem({
    Key? key,
    required this.comment,
    required this.isMine,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                comment.nickname,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              if (isMine) ...[
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.edit, size: 18, color: Colors.white54),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete, size: 18, color: Colors.white54),
                  onPressed: onDelete,
                ),
              ],
            ],
          ),
          Text(comment.content, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
