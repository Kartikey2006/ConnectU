import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart';
import 'package:connectu_alumni_platform/features/auth/presentation/pages/signup_page.dart';
import 'package:connectu_alumni_platform/features/auth/presentation/pages/onboarding_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      context.read<AuthBloc>().add(SignInRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ));
    }
  }

  void _handleGoogleSignIn() {
    // TODO: Implement Google sign in
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Sign In coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111922),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is Authenticated) {
            setState(() => _isLoading = false);
            // Navigate to dashboard based on user role
            Navigator.pushReplacementNamed(context, '/dashboard');
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button and title
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OnboardingPage()),
                      ),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'ConnectU',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.015,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the layout
                  ],
                ),
              ),

              // Welcome text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text(
                  'Welcome back!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.015,
                  ),
                ),
              ),

              // Form
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email field
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: const TextStyle(
                                color: Color(0xFF93ACC8),
                                fontSize: 16,
                              ),
                              filled: true,
                              fillColor: const Color(0xFF243447),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),

                        // Password field
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: const TextStyle(
                                color: Color(0xFF93ACC8),
                                fontSize: 16,
                              ),
                              filled: true,
                              fillColor: const Color(0xFF243447),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                        ),

                        // Google Sign In button
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _isLoading ? null : _handleGoogleSignIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1979E6),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              icon: const Icon(Icons.g_mobiledata, size: 20),
                              label: const Text(
                                'Sign in with Google',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.015,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Sign up link
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupPage()),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'Not registered? Sign up',
                              style: TextStyle(
                                color: Color(0xFF93ACC8),
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
