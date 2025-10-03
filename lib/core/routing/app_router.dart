import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectu_alumni_platform/core/utils/navigation_utils.dart';
import 'package:connectu_alumni_platform/features/auth/presentation/pages/login_page.dart';
import 'package:connectu_alumni_platform/features/auth/presentation/pages/signup_page.dart';
import 'package:connectu_alumni_platform/features/auth/presentation/pages/onboarding_page.dart';
import 'package:connectu_alumni_platform/features/auth/presentation/pages/loading_page.dart';
import 'package:connectu_alumni_platform/features/auth/presentation/pages/alumni_profile_completion_page.dart';
import 'package:connectu_alumni_platform/features/dashboard/presentation/pages/home_page.dart';
import 'package:connectu_alumni_platform/features/dashboard/presentation/pages/student_dashboard_page.dart';
import 'package:connectu_alumni_platform/features/dashboard/presentation/pages/alumni_dashboard_page.dart';
import 'package:connectu_alumni_platform/features/dashboard/presentation/pages/admin_dashboard_page.dart';
import 'package:connectu_alumni_platform/features/mentorship/presentation/pages/mentorship_page.dart';
import 'package:connectu_alumni_platform/features/mentorship/presentation/pages/alumni_mentorship_page.dart';
import 'package:connectu_alumni_platform/features/mentorship/presentation/pages/mentorship_booking_page.dart';
import 'package:connectu_alumni_platform/features/mentorship/presentation/pages/smart_mentorship_page.dart';
import 'package:connectu_alumni_platform/features/webinars/presentation/pages/webinars_page.dart';
import 'package:connectu_alumni_platform/features/webinars/presentation/pages/webinar_details_page.dart';
import 'package:connectu_alumni_platform/features/events/presentation/pages/events_page.dart';
import 'package:connectu_alumni_platform/features/forums/presentation/pages/forums_page.dart';
import 'package:connectu_alumni_platform/features/referrals/presentation/pages/referrals_page.dart';
import 'package:connectu_alumni_platform/features/jobs/presentation/pages/job_postings_page.dart';
import 'package:connectu_alumni_platform/features/jobs/presentation/pages/job_details_page.dart';
import 'package:connectu_alumni_platform/features/hire/presentation/pages/hire_page.dart';
import 'package:connectu_alumni_platform/features/hire/presentation/pages/explore_resumes_page.dart';
import 'package:connectu_alumni_platform/features/hire/presentation/pages/hire_interns_page.dart';
import 'package:connectu_alumni_platform/features/hire/presentation/pages/post_job_page.dart';
import 'package:connectu_alumni_platform/features/payments/presentation/pages/donation_campaigns_page.dart';
import 'package:connectu_alumni_platform/features/payments/presentation/pages/payment_page.dart';
import 'package:connectu_alumni_platform/features/payments/data/models/payment_models.dart';
import 'package:connectu_alumni_platform/features/chat/presentation/pages/chat_list_page.dart';
import 'package:connectu_alumni_platform/features/chat/presentation/pages/chat_page.dart';
import 'package:connectu_alumni_platform/features/profile/presentation/pages/profile_page.dart';
import 'package:connectu_alumni_platform/features/dashboard/presentation/pages/student_profile_page.dart';
import 'package:connectu_alumni_platform/features/notifications/presentation/pages/notifications_page.dart';
import 'package:connectu_alumni_platform/features/alumni/presentation/pages/alumni_page.dart';
import 'package:connectu_alumni_platform/features/alumni/presentation/pages/alumni_directory_page.dart';
import 'package:connectu_alumni_platform/features/alumni/presentation/pages/alumni_profile_view_page.dart';
import 'package:connectu_alumni_platform/features/mentorship/presentation/pages/alumni_requests_page.dart';
import 'package:connectu_alumni_platform/features/webinars/presentation/pages/alumni_webinars_page.dart';
import 'package:connectu_alumni_platform/features/donations/presentation/pages/alumni_donations_page.dart';
import 'package:connectu_alumni_platform/features/networking/presentation/pages/alumni_network_page.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart'
    as auth_bloc;
import 'package:connectu_alumni_platform/test_navigation.dart';

class AppRouter {
  static GoRouter createRouter(auth_bloc.AuthBloc authBloc) {
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) async {
        // Get the current authentication state
        final authState = authBloc.state;

        print(
            '🔄 Router redirect - Current state: ${authState.runtimeType}, Path: ${state.uri.path}');

        // If authentication is still loading, show loading page
        if (authState is auth_bloc.AuthLoading) {
          print('⏳ Redirecting to loading page');
          return '/loading';
        }

        // If user is authenticated, redirect to appropriate dashboard
        if (authState is auth_bloc.Authenticated) {
          final userRole = authState.user.user.role.name;
          String dashboardRoute;
          switch (userRole) {
            case 'student':
              dashboardRoute = '/student-dashboard';
              break;
            case 'alumni':
              // For alumni, check if they need to complete their profile
              // Check database first, then local storage as fallback
              bool isProfileCompleted =
                  authState.user.user.isProfileCompleted == true;

              // If database doesn't have the field yet, check local storage
              if (!isProfileCompleted) {
                try {
                  final prefs = await SharedPreferences.getInstance();
                  final userId = authState.user.user.id;
                  isProfileCompleted =
                      prefs.getBool('profile_completed_$userId') ?? false;
                } catch (e) {
                  print(
                      '❌ Error checking local storage for profile completion: $e');
                }
              }

              if (isProfileCompleted) {
                dashboardRoute = '/alumni-dashboard';
              } else {
                dashboardRoute = '/alumni-profile-completion';
              }
              break;
            case 'admin':
              dashboardRoute = '/admin-dashboard';
              break;
            default:
              dashboardRoute = '/student-dashboard';
          }

          // Redirect if on root path or auth pages only
          final authPages = [
            '/',
            '/login',
            '/signup',
            '/onboarding',
            '/loading'
          ];
          if (authPages.contains(state.uri.path)) {
            print('✅ Redirecting authenticated user to: $dashboardRoute');
            return dashboardRoute;
          }
        }

        // If user is not authenticated and trying to access protected routes
        if (authState is auth_bloc.Unauthenticated ||
            authState is auth_bloc.AuthInitial) {
          final protectedRoutes = [
            '/student-dashboard',
            '/alumni-dashboard',
            '/admin-dashboard',
            '/mentorship',
            '/webinars',
            '/referrals',
            '/chat',
            '/profile',
            '/notifications',
          ];

          if (protectedRoutes.contains(state.uri.path)) {
            print('🔒 Redirecting unauthenticated user to login');
            return '/login';
          }
        }

        print('✅ No redirect needed');
        return null; // No redirect needed
      },
      routes: [
        // Loading Route
        GoRoute(
          path: '/loading',
          builder: (context, state) => const LoadingPage(),
        ),

        // Home Route
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),

        // Auth Routes
        GoRoute(
          path: '/onboarding',
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

        // Alumni Profile Completion Route
        GoRoute(
          path: '/alumni-profile-completion',
          builder: (context, state) => const AlumniProfileCompletionPage(),
        ),

        // Dashboard Routes
        GoRoute(
          path: '/student-dashboard',
          builder: (context, state) => const StudentDashboardPage(),
        ),
        GoRoute(
          path: '/alumni',
          builder: (context, state) => const AlumniPage(),
        ),
        GoRoute(
          path: '/alumni-profile/:alumniId',
          builder: (context, state) {
            final alumniId = state.pathParameters['alumniId'] ?? '1';
            return AlumniProfileViewPage(alumniId: alumniId);
          },
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
          builder: (context, state) {
            // For now, default to student mentorship page
            // Role-based routing will be handled by the dashboard navigation
            return const MentorshipPage();
          },
        ),
        GoRoute(
          path: '/alumni-mentorship',
          builder: (context, state) => const AlumniMentorshipPage(),
        ),
        GoRoute(
          path: '/mentorship/booking/:sessionId',
          builder: (context, state) {
            final sessionId = state.pathParameters['sessionId']!;
            return MentorshipBookingPage(sessionId: sessionId);
          },
        ),
        GoRoute(
          path: '/smart-mentorship',
          builder: (context, state) => const SmartMentorshipPage(),
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

        // Events Routes
        GoRoute(
          path: '/events',
          builder: (context, state) => const EventsPage(),
        ),

        // Forums Routes
        GoRoute(
          path: '/forums',
          builder: (context, state) => const ForumsPage(),
        ),

        // Referral Routes
        GoRoute(
          path: '/referrals',
          builder: (context, state) => const ReferralsPage(),
        ),

        // Job Routes
        GoRoute(
          path: '/jobs',
          builder: (context, state) => const JobPostingsPage(),
        ),

        // HIRE Routes (Alumni-specific)
        GoRoute(
          path: '/hire',
          builder: (context, state) => const HirePage(),
        ),
        GoRoute(
          path: '/hire/explore-resumes',
          builder: (context, state) => const ExploreResumesPage(),
        ),
        GoRoute(
          path: '/hire/hire-interns',
          builder: (context, state) => const HireInternsPage(),
        ),
        GoRoute(
          path: '/hire/post-job',
          builder: (context, state) => const PostJobPage(),
        ),
        GoRoute(
          path: '/job-details/:jobId',
          builder: (context, state) {
            final jobId = state.pathParameters['jobId'] ?? '1';
            // For now, we'll pass a mock job object
            // In a real app, you'd fetch the job details based on jobId
            final mockJob = {
              'id': jobId,
              'title': 'Senior Software Engineer',
              'company': 'Google',
              'location': 'Bangalore',
              'type': 'Full-time',
              'salary': '₹15-25 LPA',
              'experience': '3-5 years',
              'description':
                  'We are looking for a Senior Software Engineer to join our team. You will be responsible for developing and maintaining our core products. This role involves working with cutting-edge technologies and collaborating with cross-functional teams.',
              'skills': ['Flutter', 'Dart', 'Firebase', 'REST APIs', 'Git'],
              'postedBy': 'Sarah Chen',
              'postedDate': '2 days ago',
              'category': 'Technology',
              'companyLogo': null,
            };
            return JobDetailsPage(job: mockJob);
          },
        ),

        // Payment Routes
        GoRoute(
          path: '/donation-campaigns',
          builder: (context, state) => const DonationCampaignsPage(),
        ),
        GoRoute(
          path: '/payment',
          builder: (context, state) {
            // This would need to be passed from the calling page
            // For now, we'll create a dummy payment request
            final paymentRequest = PaymentRequest(
              id: 'dummy',
              amount: 1000,
              description: 'Sample Payment',
              type: PaymentType.donation,
            );
            return PaymentPage(paymentRequest: paymentRequest);
          },
        ),

        // Community Routes
        GoRoute(
          path: '/forums',
          builder: (context, state) => const ForumsPage(),
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
        GoRoute(
          path: '/student-profile',
          builder: (context, state) => const StudentProfilePage(),
        ),

        // Notification Routes
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationsPage(),
        ),

        // Alumni-specific Routes
        GoRoute(
          path: '/alumni-requests',
          builder: (context, state) => const AlumniRequestsPage(),
        ),
        GoRoute(
          path: '/alumni-webinars',
          builder: (context, state) => const AlumniWebinarsPage(),
        ),
        GoRoute(
          path: '/alumni-donations',
          builder: (context, state) => const AlumniDonationsPage(),
        ),
        GoRoute(
          path: '/alumni-network',
          builder: (context, state) => const AlumniNetworkPage(),
        ),
        GoRoute(
          path: '/alumni-directory',
          builder: (context, state) => const AlumniDirectoryPage(),
        ),

        // Test Navigation Route
        GoRoute(
          path: '/test-navigation',
          builder: (context, state) => const TestNavigationPage(),
        ),
      ],
      errorBuilder: (context, state) {
        // Handle navigation errors and exceptions gracefully
        return Scaffold(
          backgroundColor: const Color(0xFF111922), // Match app theme
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 72,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Oops! Something went wrong',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.error?.toString() ?? "Page not found"}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          try {
                            context.go('/');
                          } catch (e) {
                            // Fallback if even home navigation fails
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1979E6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Go to Home',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => NavigationUtils.safeBack(context),
                      child: const Text(
                        'Go Back',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Stream listener for GoRouter to refresh when auth state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<auth_bloc.AuthState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (auth_bloc.AuthState state) {
        notifyListeners();
      },
    );
  }

  late final StreamSubscription<auth_bloc.AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
