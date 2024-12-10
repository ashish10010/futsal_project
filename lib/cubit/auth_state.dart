part of 'auth_cubit.dart';

abstract class AuthState extends Equatable{
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSignUp extends AuthState {}

final class AuthLoggedIn extends AuthState {
  final UserModel user;
  const AuthLoggedIn({required this.user});
   @override
  List<Object?> get props => [user];
  
}

final class AuthError extends AuthState {
  final String error;
  const AuthError(this.error);
}
