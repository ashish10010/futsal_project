import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/src/features/auth/data/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/auth_service.dart';
import '../service/user_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  final UserService _userService;

  AuthCubit(this._authService, this._userService) : super(AuthInitial());


  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      final user = await _authService.signIn(
        email: email,
        password: password,
      );
        emit(AuthLoggedIn(user: user));

    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      emit(AuthLoading());
      await _authService.signUp(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      emit(AuthSignUp());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

 
  void signOut() async {
    try {
      emit(AuthLoading());
      await _authService.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Get current user details based on the token
  Future<void> getCurrentUser() async {
    try {
      emit(AuthLoading());
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      if (userId == null) {
        emit(AuthError('No user found'));
        return;
      }

      final user = await _userService.fetchUserById(userId);
      emit(AuthLoggedIn( user: user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
