// 

import '../src/features/auth/data/model/user_model.dart';

class UserService {
  /// Mocked Get User by ID
  Future<UserModel> getUserById(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: id,
      name: 'Mock User',
      email: 'mockuser@example.com',
      photo: null,
    );
  }

  /// Mocked Save User
  Future<void> setUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
