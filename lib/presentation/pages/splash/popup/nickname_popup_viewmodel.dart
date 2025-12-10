import 'package:flutter/material.dart';
import '../../../../data/repository/user_repository_impl.dart';
import '../../../../domain/entity/user.dart';

class NicknamePopupViewModel extends ChangeNotifier {
  final UserRepositoryImpl _userRepository;
  final String uid;
  final String email;
  final String provider;

  NicknamePopupViewModel({
    required UserRepositoryImpl userRepository,
    required this.uid,
    required this.email,
    required this.provider,
  }) : _userRepository = userRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> saveNickname(String nickname) async {
    _isLoading = true;
    notifyListeners();
    final user = User(
      id: uid,
      nickname: nickname,
      email: email,
      provider: provider,
    );
    await _userRepository.saveUser(user);
    _isLoading = false;
    notifyListeners();
  }
}
