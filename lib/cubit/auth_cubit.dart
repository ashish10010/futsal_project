import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../src/features/auth/data/model/user_model.dart';
import '../service/auth_service.dart';
import '../service/user_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  final UserService _userService;

  AuthCubit(this._authService, this._userService) : super(AuthInitial());

  /// Sign in a user via API
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

  /// Sign up a user via API
  void signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      emit(AuthLoading());
      // Replace Firebase logic with API call in AuthService
      UserModel user = await _authService.signUp(
        name: name,
        email: email,
        password: password,
        role: role,
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
      // Replace Firebase sign-out logic with API-based token invalidation
      await _authService.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  /// Get current user details based on the token
  void getCurrentUser() async {
    try {
      emit(AuthLoading());
      // Fetch user details using the token
      final user = await _userService.fetchCurrentUser();
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }
}
