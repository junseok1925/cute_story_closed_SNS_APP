import '../../domain/entity/user.dart';

abstract class UserRepository {
  Future<User?> fetchUser(String id);
  Future<void> saveUser(User user);
}
