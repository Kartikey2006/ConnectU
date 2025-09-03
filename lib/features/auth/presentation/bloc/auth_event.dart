part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String name;
  final String role;

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.name,
    required this.role,
  });

  @override
  List<Object> get props => [email, password, confirmPassword, name, role];
}

class SignOutRequested extends AuthEvent {}

class GoogleSignInRequested extends AuthEvent {}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}
