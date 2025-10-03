import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart';
import 'package:connectu_alumni_platform/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:connectu_alumni_platform/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:connectu_alumni_platform/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:connectu_alumni_platform/core/routing/app_router.dart';

void main() {
  runApp(const StudentSignupQuickTestApp());
}

class StudentSignupQuickTestApp extends StatelessWidget {
  const StudentSignupQuickTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Student Signup Quick Test',
      routerConfig: AppRouter.router,
      home: BlocProvider(
        create: (context) => AuthBloc(
          AuthRepositoryImpl(
            AuthRemoteDataSourceImpl(),
            AuthLocalDataSourceImpl(),
          ),
        ),
        child: const StudentSignupQuickTestPage(),
      ),
    );
  }
}

class StudentSignupQuickTestPage extends StatefulWidget {
  const StudentSignupQuickTestPage({super.key});

  @override
  _StudentSignupQuickTestPageState createState() =>
      _StudentSignupQuickTestPageState();
}

class _StudentSignupQuickTestPageState
    extends State<StudentSignupQuickTestPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Signup Quick Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Student signup successful! Redirecting to dashboard...')),
                  );
                  // The router will handle the redirect
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Signup failed: ${state.message}')),
                  );
                }
              },
              child: ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        SignUpRequested(
                          email: _emailController.text,
                          password: _passwordController.text,
                          name: _nameController.text,
                          role: 'student', // Force student role
                          confirmPassword: _passwordController.text,
                        ),
                      );
                },
                child: const Text('Test Student Signup'),
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const CircularProgressIndicator();
                } else if (state is AuthSuccess) {
                  return Text('✅ Success! User: ${state.user.email}');
                } else if (state is AuthFailure) {
                  return Text('❌ Error: ${state.message}');
                }
                return const Text('Ready to test student signup');
              },
            ),
          ],
        ),
      ),
    );
  }
}
