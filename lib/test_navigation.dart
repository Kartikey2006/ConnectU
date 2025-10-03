import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TestNavigationPage extends StatelessWidget {
  const TestNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Navigation Test Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                print('🧪 Testing navigation to /alumni');
                context.go('/alumni');
              },
              child: const Text('Test Alumni Page'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('🧪 Testing navigation to /mentorship');
                context.go('/mentorship');
              },
              child: const Text('Test Mentorship Page'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('🧪 Testing navigation to /notifications');
                context.go('/notifications');
              },
              child: const Text('Test Notifications Page'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('🧪 Testing navigation to /referrals');
                context.go('/referrals');
              },
              child: const Text('Test Referrals Page'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('🧪 Testing navigation to /webinars');
                context.go('/webinars');
              },
              child: const Text('Test Webinars Page'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                print('🧪 Testing navigation back to student dashboard');
                context.go('/student-dashboard');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Back to Student Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
