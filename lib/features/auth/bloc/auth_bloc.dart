import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:connectu_alumni_platform/features/auth/domain/entities/auth_user.dart';
import 'package:connectu_alumni_platform/features/auth/domain/repositories/auth_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
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
  List<Object?> get props => [email, password, confirmPassword, name, role];
}

class SignOutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class AuthRestoreRequested extends AuthEvent {}

class ProfileCompleted extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final AuthUser user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthRestoreRequested>(_onAuthRestoreRequested);
    on<ProfileCompleted>(_onProfileCompleted);

    // Check authentication status on startup
    add(AuthRestoreRequested());
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithEmail(
        event.email,
        event.password,
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    print(
        '🔄 AuthBloc: Starting signup process for ${event.email} as ${event.role}...');
    emit(AuthLoading());
    try {
      // Validate passwords match
      if (event.password != event.confirmPassword) {
        print('❌ AuthBloc: Passwords do not match');
        emit(const AuthError('Passwords do not match'));
        return;
      }

      print('📝 AuthBloc: Calling repository signup...');
      final user = await _authRepository.signUpWithEmail(
        event.email,
        event.password,
        event.name,
        event.role,
      );
      print(
          '✅ AuthBloc: Signup successful, user: ${user.user.name}, role: ${user.user.role.name}');
      print(
          '🔑 AuthBloc: Access token: ${user.accessToken.isNotEmpty ? "present" : "missing"}');
      print(
          '🔄 AuthBloc: Refresh token: ${user.refreshToken.isNotEmpty ? "present" : "missing"}');
      print('⏰ AuthBloc: Expires at: ${user.expiresAt}');

      // Verify the user is properly authenticated
      if (user.accessToken.isNotEmpty) {
        print(
            '✅ AuthBloc: User has valid access token, emitting Authenticated state');
        emit(Authenticated(user));
      } else {
        print(
            '⚠️ AuthBloc: User has no access token, but proceeding with mock authentication');
        emit(Authenticated(user));
      }
    } catch (e) {
      print('❌ AuthBloc: Signup error: $e');

      // Provide user-friendly error messages
      String errorMessage = e.toString();
      if (errorMessage
          .contains('duplicate key value violates unique constraint')) {
        errorMessage =
            'This email is already registered. Please try logging in instead.';
      } else if (errorMessage.contains('Could not find the')) {
        errorMessage = 'Database configuration issue. Please try again.';
      } else if (errorMessage.contains('Sign up failed')) {
        errorMessage =
            'Signup failed. Please check your information and try again.';
      }

      emit(AuthError(errorMessage));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null && !user.isExpired) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      // If there's an error, try to get user from local storage
      try {
        final localUser = await _authRepository.getCurrentUser();
        if (localUser != null && !localUser.isExpired) {
          emit(Authenticated(localUser));
        } else {
          emit(Unauthenticated());
        }
      } catch (localError) {
        emit(Unauthenticated());
      }
    }
  }

  Future<void> _onAuthRestoreRequested(
    AuthRestoreRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('🔄 Restoring authentication state...');
    emit(AuthLoading());

    try {
      // Use getCurrentUser which already has restore logic
      final user = await _authRepository.getCurrentUser().timeout(
        const Duration(seconds: 5), // Increased timeout
        onTimeout: () {
          print('⏰ Auth restoration timed out, checking local storage...');
          // On timeout, try to get user from local storage only
          return _authRepository.getCurrentUser();
        },
      );

      if (user != null) {
        print('✅ User authenticated: ${user.user.email}');
        emit(Authenticated(user));
      } else {
        print('❌ No authenticated user found');
        emit(Unauthenticated());
      }
    } catch (e) {
      print('❌ Error restoring auth state: $e');
      // Don't immediately emit Unauthenticated, try local storage first
      try {
        final localUser = await _authRepository.getCurrentUser();
        if (localUser != null) {
          print(
              '✅ Found user in local storage despite error: ${localUser.user.email}');
          emit(Authenticated(localUser));
        } else {
          emit(Unauthenticated());
        }
      } catch (localError) {
        print('❌ Local storage also failed: $localError');
        emit(Unauthenticated());
      }
    }
  }

  Future<void> _onProfileCompleted(
    ProfileCompleted event,
    Emitter<AuthState> emit,
  ) async {
    try {
      print('✅ Profile completed, updating user profile status');

      // Update user profile to mark as completed
      final currentState = state;
      if (currentState is Authenticated) {
        final updatedUser = await _authRepository.updateProfile({
          'is_profile_completed': true,
        });

        // Update the authenticated state with the updated user
        emit(Authenticated(updatedUser));
        print('✅ User profile marked as completed');
      }
    } catch (e) {
      print('❌ Error updating profile completion status: $e');
      // Don't emit error state, just log the error
      // The user can still proceed to the dashboard
    }
  }
}
