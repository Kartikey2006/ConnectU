// Test script to verify authentication persistence
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart';
import 'package:connectu_alumni_platform/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:connectu_alumni_platform/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:connectu_alumni_platform/features/auth/data/datasources/auth_local_datasource.dart';

class AuthPersistenceTestWidget extends StatefulWidget {
  const AuthPersistenceTestWidget({super.key});

  @override
  State<AuthPersistenceTestWidget> createState() => _AuthPersistenceTestWidgetState();
}

class _AuthPersistenceTestWidgetState extends State<AuthPersistenceTestWidget> {
  late AuthRepositoryImpl authRepository;

  @override
  void initState() {
    super.initState();
    authRepository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(),
      localDataSource: AuthLocalDataSourceImpl(),
    );
  }

  Future<void> testLocalStorage() async {
    print('🧪 Testing local storage persistence...');
    
    try {
      // Test if there's a saved user
      final hasUser = await authRepository.localDataSource.hasAuthUser();
      print('📱 Has local user: $hasUser');
      
      if (hasUser) {
        final user = await authRepository.localDataSource.getAuthUser();
        if (user != null) {
          print('✅ Found local user: ${user.user.email}');
          print('⏰ Token expires at: ${user.expiresAt}');
          print('⚡ Is expired: ${user.isExpired}');
        } else {
          print('❌ Local user is null');
        }
      }
      
      // Test current user retrieval
      final currentUser = await authRepository.getCurrentUser();
      if (currentUser != null) {
        print('✅ Current user: ${currentUser.user.email}');
      } else {
        print('❌ No current user found');
      }
    } catch (e) {
      print('❌ Test error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(authRepository),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Auth Persistence Test'),
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Current Auth State: ${state.runtimeType}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  if (state is Authenticated) ...[
                    Text('User: ${state.user.user.email}'),
                    Text('Role: ${state.user.user.role}'),
                    Text('Expires: ${state.user.expiresAt}'),
                    Text('Is Expired: ${state.user.isExpired}'),
                  ],
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthRestoreRequested());
                    },
                    child: const Text('Test Auth Restore'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: testLocalStorage,
                    child: const Text('Test Local Storage'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthCheckRequested());
                    },
                    child: const Text('Check Auth Status'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
