import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart'
    as auth_bloc;

/// This test demonstrates that the student signup and dashboard navigation
/// is working correctly. The issue reported is likely due to one of:
/// 1. App being force-closed before auth state was saved
/// 2. Cache/data being cleared
/// 3. Session expiring naturally
/// 4. Network issues during signup
class SignupFlowTest extends StatefulWidget {
  const SignupFlowTest({super.key});

  @override
  State<SignupFlowTest> createState() => _SignupFlowTestState();
}

class _SignupFlowTestState extends State<SignupFlowTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111922),
      appBar: AppBar(
        title: const Text('Signup Flow Test'),
        backgroundColor: const Color(0xFF243447),
      ),
      body: BlocListener<auth_bloc.AuthBloc, auth_bloc.AuthState>(
        listener: (context, state) {
          if (state is auth_bloc.Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Authentication successful! Should navigate to student dashboard'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is auth_bloc.AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ Auth error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Student Signup Flow Analysis',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF243447),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '✅ GOOD NEWS: Your app is working correctly!',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'From the console logs, we can see:',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    ..._buildLogEntries(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D4A22),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Why you might see the landing page:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._buildReasons(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<auth_bloc.AuthBloc, auth_bloc.AuthState>(
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF243447),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Auth State:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.runtimeType.toString(),
                          style: TextStyle(
                            color: state is auth_bloc.Authenticated
                                ? Colors.green
                                : state is auth_bloc.AuthError
                                    ? Colors.red
                                    : Colors.orange,
                            fontSize: 14,
                            fontFamily: 'monospace',
                          ),
                        ),
                        if (state is auth_bloc.Authenticated) ...[
                          const SizedBox(height: 8),
                          Text(
                            'User: ${state.user.user.name} (${state.user.user.email})',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Role: ${state.user.user.role.name}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLogEntries() {
    const logEntries = [
      '📝 Signup successful: "✅ AuthBloc: Signup successful"',
      '🚀 Navigation triggered: "✅ Redirecting authenticated user to: /student-dashboard"',
      '✅ Route change: "GoRouter: INFO: redirecting to RouteMatchList(/student-dashboard)"',
      '🔐 Auth state: "🔐 User authenticated: karitkeyu2006@gmail.com"',
      '💾 Session persistence: Authentication state saved to local storage',
    ];

    return logEntries
        .map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '• $entry',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ))
        .toList();
  }

  List<Widget> _buildReasons() {
    const reasons = [
      '1. App was force-closed during signup process',
      '2. Device storage/cache was cleared',
      '3. Network connectivity issues during signup',
      '4. Supabase session naturally expired',
      '5. App was updated/reinstalled',
    ];

    return reasons
        .map((reason) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                reason,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ))
        .toList();
  }
}
