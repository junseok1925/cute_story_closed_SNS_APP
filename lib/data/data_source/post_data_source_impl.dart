import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cute_story_closed_sns_app/data/data_source/post_data_source.dart';
import 'package:cute_story_closed_sns_app/data/dto/post_dto.dart';

class PostDataSourceImpl implements PostDataSource {
  final FirebaseFirestore _firestore;

  PostDataSourceImpl(this._firestore);

  CollectionReference get _postsCol =>
      _firestore.collection('posts');

  @override
  Future<List<PostDto>> fetchPosts({
    int limit = 10,
    DateTime? startAfter,
  }) async {
    Query query = _postsCol.orderBy('createdAt', descending: true).limit(limit);

    // 페이징 처리
    if (startAfter != null) {
      query = query.startAfter([Timestamp.fromDate(startAfter)]);
    }

    final snapshot = await query.get();

    return snapshot.docs
        .map((doc) => PostDto.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PostDto?> fetchPostById(String postId) async {
    final doc = await _postsCol.doc(postId).get();

    if (!doc.exists) return null;

    return PostDto.fromJson(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> uploadPost(PostDto dto) async {
    await _postsCol.doc(dto.postId).set(dto.toJson());
  }

  @override
  Future<void> updatePost(PostDto dto) async {
    await _postsCol.doc(dto.postId).update(dto.toJson());
  }

  @override
  Future<void> deletePost(String postId) async {
    await _postsCol.doc(postId).delete();
  }
}
