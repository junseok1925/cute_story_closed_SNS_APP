import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cute_story_closed_sns_app/data/data_source/post_data_source.dart';
import 'package:cute_story_closed_sns_app/data/dto/post_dto.dart';

class PostDataSourceImpl implements PostDataSource {
  final FirebaseFirestore _firestore;

  PostDataSourceImpl(this._firestore);

  CollectionReference get _postsCol =>
      _firestore.collection('posts');
  CollectionReference get _likesCol => _firestore.collection('likes');

  @override
  Future<List<PostDto>> fetchPosts({
    int limit = 10,
    DateTime? startAfter,
    String? location,
  }) async {
    Query query;
    if (location != null && location.isNotEmpty) {
      // Firestore composite index 없이 동작하도록 location만 필터링 후 클라이언트에서 정렬
      query = _postsCol.where('location', isEqualTo: location);
    } else {
      query = _postsCol.orderBy('createdAt', descending: true).limit(limit);
      // 페이징 처리
      if (startAfter != null) {
        query = query.startAfter([Timestamp.fromDate(startAfter)]);
      }
    }

    final snapshot = await query.get();

    final list = snapshot.docs
        .map(
          (doc) => PostDto.fromDoc(
            doc as DocumentSnapshot<Map<String, dynamic>>,
          ),
        )
        .toList();

    // location 필터 사용 시에는 클라이언트에서 최신순 정렬
    if (location != null && location.isNotEmpty) {
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return list;
  }

  @override
  Future<PostDto?> fetchPostById(String postId) async {
    final doc = await _postsCol.doc(postId).get();

    if (!doc.exists) return null;

    return PostDto.fromDoc(doc as DocumentSnapshot<Map<String, dynamic>>);
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

  @override
  Future<void> addLike({
    required String postId,
    required String userId,
    required String nickname,
    required DateTime createdAt,
  }) async {
    final likeDoc = _likesCol.doc('${postId}_$userId');

    await _firestore.runTransaction((txn) async {
      final likeSnap = await txn.get(likeDoc);
      if (likeSnap.exists) {
        return;
      }

      txn.set(likeDoc, {
        'postId': postId,
        'userId': userId,
        'nickname': nickname,
        'createdAt': Timestamp.fromDate(createdAt),
      });

      txn.update(_postsCol.doc(postId), {
        'likeCount': FieldValue.increment(1),
      });
    });
  }

  @override
  Future<bool> isLiked({
    required String postId,
    required String userId,
  }) async {
    final likeDoc = await _likesCol.doc('${postId}_$userId').get();
    return likeDoc.exists;
  }

  @override
  Future<void> removeLike({
    required String postId,
    required String userId,
  }) async {
    final likeDoc = _likesCol.doc('${postId}_$userId');

    await _firestore.runTransaction((txn) async {
      final likeSnap = await txn.get(likeDoc);
      if (!likeSnap.exists) {
        return;
      }

      txn.delete(likeDoc);
      txn.update(_postsCol.doc(postId), {
        'likeCount': FieldValue.increment(-1),
      });
    });
  }
}
