import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:connectu_alumni_platform/features/auth/domain/entities/auth_user.dart';
import 'package:connectu_alumni_platform/features/auth/domain/repositories/auth_repository.dart';
import 'package:connectu_alumni_platform/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:connectu_alumni_platform/features/auth/domain/usecases/sign_up_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;

  AuthBloc({required this.authRepository})
      : signInUseCase = SignInUseCase(authRepository),
        signUpUseCase = SignUpUseCase(authRepository),
        super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final authUser = await authRepository.getCurrentUser();
      if (authUser != null) {
        emit(Authenticated(authUser));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final authUser = await signInUseCase(event.email, event.password);
      emit(Authenticated(authUser));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final authUser = await signUpUseCase(
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
        name: event.name,
        role: event.role,
      );
      emit(Authenticated(authUser));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final authUser = await authRepository.signInWithGoogle();
      emit(Authenticated(authUser));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await authRepository.forgotPassword(event.email);
      emit(PasswordResetEmailSent());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
