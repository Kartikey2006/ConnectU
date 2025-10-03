import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart';
import 'package:connectu_alumni_platform/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:connectu_alumni_platform/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:connectu_alumni_platform/features/auth/data/datasources/auth_local_datasource.dart';

void main() {
  runApp(const StudentSignupTestApp());
}

class StudentSignupTestApp extends StatelessWidget {
  const StudentSignupTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Signup Test',
      home: BlocProvider(
        create: (context) => AuthBloc(
          AuthRepositoryImpl(
            AuthRemoteDataSourceImpl(),
            AuthLocalDataSourceImpl(),
          ),
        ),
        child: const StudentSignupTestPage(),
      ),
    );
  }
}

class StudentSignupTestPage extends StatefulWidget {
  const StudentSignupTestPage({super.key});

  @override
  _StudentSignupTestPageState createState() => _StudentSignupTestPageState();
}

class _StudentSignupTestPageState extends State<StudentSignupTestPage> {
  final _emailController = TextEditingController(text: 'teststudent${DateTime.now().millisecondsSinceEpoch}@example.com');
  final _passwordController = TextEditingController(text: 'password123');
  final _nameController = TextEditingController(text: 'Test Student');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Signup Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Test Student Signup',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is Authenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Signup successful! User: ${state.user.name}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Navigate to student dashboard
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StudentDashboardTest(),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state is AuthLoading
                      ? null
                      : () {
                          context.read<AuthBloc>().add(
                            SignUpRequested(
                              email: _emailController.text,
                              password: _passwordController.text,
                              name: _nameController.text,
                              role: 'student',
                            ),
                          );
                        },
                  child: state is AuthLoading
                      ? const CircularProgressIndicator()
                      : const Text('Sign Up as Student'),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginTestPage(),
                  ),
                );
              },
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentDashboardTest extends StatelessWidget {
  const StudentDashboardTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              'Student Signup Successful!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'You are now on the student dashboard.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginTestPage extends StatelessWidget {
  const LoginTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Test'),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text('Login page would go here'),
      ),
    );
  }
}
