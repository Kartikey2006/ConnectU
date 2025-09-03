import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/features/auth/presentation/pages/login_page.dart';
import 'package:connectu_alumni_platform/features/auth/presentation/pages/signup_page.dart';
import 'package:connectu_alumni_platform/features/auth/presentation/pages/onboarding_page.dart';
import 'package:connectu_alumni_platform/features/dashboard/presentation/pages/student_dashboard_page.dart';
import 'package:connectu_alumni_platform/features/dashboard/presentation/pages/alumni_dashboard_page.dart';
import 'package:connectu_alumni_platform/features/dashboard/presentation/pages/admin_dashboard_page.dart';
import 'package:connectu_alumni_platform/features/mentorship/presentation/pages/mentorship_page.dart';
import 'package:connectu_alumni_platform/features/mentorship/presentation/pages/mentorship_booking_page.dart';
import 'package:connectu_alumni_platform/features/webinars/presentation/pages/webinars_page.dart';
import 'package:connectu_alumni_platform/features/webinars/presentation/pages/webinar_details_page.dart';
import 'package:connectu_alumni_platform/features/referrals/presentation/pages/referrals_page.dart';
import 'package:connectu_alumni_platform/features/chat/presentation/pages/chat_list_page.dart';
import 'package:connectu_alumni_platform/features/chat/presentation/pages/chat_page.dart';
import 'package:connectu_alumni_platform/features/profile/presentation/pages/profile_page.dart';
import 'package:connectu_alumni_platform/features/notifications/presentation/pages/notifications_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Auth Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
      
      // Dashboard Routes
      GoRoute(
        path: '/student-dashboard',
        builder: (context, state) => const StudentDashboardPage(),
      ),
      GoRoute(
        path: '/alumni-dashboard',
        builder: (context, state) => const AlumniDashboardPage(),
      ),
      GoRoute(
        path: '/admin-dashboard',
        builder: (context, state) => const AdminDashboardPage(),
      ),
      
      // Mentorship Routes
      GoRoute(
        path: '/mentorship',
        builder: (context, state) => const MentorshipPage(),
      ),
      GoRoute(
        path: '/mentorship/booking/:sessionId',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          return MentorshipBookingPage(sessionId: sessionId);
        },
      ),
      
      // Webinar Routes
      GoRoute(
        path: '/webinars',
        builder: (context, state) => const WebinarsPage(),
      ),
      GoRoute(
        path: '/webinars/:webinarId',
        builder: (context, state) {
          final webinarId = state.pathParameters['webinarId']!;
          return WebinarDetailsPage(webinarId: webinarId);
        },
      ),
      
      // Referral Routes
      GoRoute(
        path: '/referrals',
        builder: (context, state) => const ReferralsPage(),
      ),
      
      // Chat Routes
      GoRoute(
        path: '/chat',
        builder: (context, state) => const ChatListPage(),
      ),
      GoRoute(
        path: '/chat/:userId',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return ChatPage(userId: userId);
        },
      ),
      
      // Profile Routes
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      
      // Notification Routes
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
