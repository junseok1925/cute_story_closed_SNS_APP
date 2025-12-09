import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entity/user.dart';
import '../../domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final _users = FirebaseFirestore.instance.collection('users');

  @override
  Future<User?> fetchUser(String id) async {
    final doc = await _users.doc(id).get();
    if (!doc.exists) return null;
    return User.fromMap(doc.data()!, doc.id);
  }

  @override
  Future<void> saveUser(User user) async {
    await _users.doc(user.id).set(user.toMap(), SetOptions(merge: true));
  }
}
