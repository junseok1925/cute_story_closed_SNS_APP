import 'package:cute_story_closed_sns_app/presentation/pages/comments/comment_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/comments/comments_view_model.dart';
import 'package:cute_story_closed_sns_app/presentation/pages/comments/comment_dialog.dart';

class CommentsPage extends ConsumerStatefulWidget {
  final String postId;
  final VoidCallback? onClose;
  final ScrollController scrollController;

  const CommentsPage({
    Key? key,
    required this.postId,
    this.onClose,
    required this.scrollController,
  }) : super(key: key);

  @override
  ConsumerState<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends ConsumerState<CommentsPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(commentsViewModelProvider(widget.postId));
    final commentsAsync = viewModel.commentsAsync;
    final isLoading = viewModel.isLoading;
    return Container(
      height: 400,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1)),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        widget.onClose?.call();
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: commentsAsync.when(
                    loading: () => Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('댓글을 불러올 수 없습니다.')),
                    data: (comments) => comments.isEmpty
                        ? Center(child: Text('댓글이 없습니다.'))
                        : ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: comments.length,
                            itemBuilder: (context, idx) {
                              final c = comments[idx];
                              final isMine = viewModel.isMine(c);
                              return CommentItem(
                                comment: c,
                                isMine: isMine,
                                onEdit: () async {
                                  final result = await showEditCommentDialog(
                                    context,
                                    c.content,
                                  );
                                  if (result != null && result.isNotEmpty) {
                                    await viewModel.updateComment(c, result);
                                  }
                                },
                                onDelete: () async {
                                  final confirm = await showDeleteCommentDialog(
                                    context,
                                  );
                                  if (confirm == true) {
                                    await viewModel.deleteComment(c);
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '  댓글을 입력해 보세요.',
                          hintStyle: TextStyle(color: Colors.white54),
                          prefixIcon: Icon(Icons.comment, color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white54,
                              width: 1,
                            ),
                          ),
                        ),
                        onSubmitted: (_) async {
                          final text = _controller.text.trim();
                          if (text.isEmpty || isLoading) return;
                          await viewModel.addComment(text);
                          _controller.clear();
                        },
                      ),
                    ),

                    SizedBox(width: 8),
                    isLoading
                        ? CircularProgressIndicator()
                        : IconButton(
                            icon: Icon(Icons.send, color: Colors.white),
                            onPressed: () async {
                              final text = _controller.text.trim();
                              if (text.isEmpty || isLoading) return;
                              await viewModel.addComment(text);
                              _controller.clear();
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
