import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_models.dart';
import '../service/auth_service.dart';
import '../service/user_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  final UserService _userService;

  AuthCubit(this._authService, this._userService) : super(AuthInitial());

  /// Sign in a user
  void signIn({required String email, required String password}) async {
    try {
      emit(AuthLoading());
      UserModel user =
          await _authService.signIn(email: email, password: password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  /// Sign up a user
  void signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      UserModel user = await _authService.signUp(
        name: name,
        email: email,
        password: password,
      );
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  /// Sign out the current user
  void signOut() async {
    try {
      emit(AuthLoading());
      await _authService.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  void getCurrentUser(String id) async {
    try {
      UserModel user = await _userService.getUserById(id);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }
}
