# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

ConnectU Alumni Platform is a comprehensive Flutter application that connects students and alumni for mentorship, referrals, webinars, and career growth. The application follows Clean Architecture principles with feature-based modularization.

## Common Development Commands

### Environment Setup
```bash
# Install Flutter dependencies
flutter pub get

# Clean and rebuild packages
flutter clean && flutter pub get

# Generate code for Hive adapters and other build_runner tasks
dart run build_runner build --delete-conflicting-outputs
```

### Development & Testing
```bash
# Run the app in debug mode
flutter run

# Run on specific device
flutter run -d windows
flutter run -d android
flutter run -d chrome

# Run tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Analyze code for issues
flutter analyze

# Check formatting
dart format --set-exit-if-changed .

# Fix formatting
dart format .
```

### Build & Release
```bash
# Build Android APK
flutter build apk --release

# Build Android App Bundle (for Play Store)
flutter build appbundle --release

# Build for Windows
flutter build windows --release

# Build for Web
flutter build web --release
```

### Code Generation
```bash
# Generate Bloc boilerplate and Hive adapters
dart run build_runner build

# Watch for changes and auto-generate
dart run build_runner watch
```

## Architecture Overview

### Clean Architecture Structure
The app follows Clean Architecture with clear separation of concerns:

- **Domain Layer**: Business entities, repositories (interfaces), and use cases
- **Data Layer**: Repository implementations, data sources (remote/local), and models
- **Presentation Layer**: UI components, BLoC state management, and pages

### Feature-Based Organization
```
lib/
├── core/                    # Core functionality shared across features
│   ├── config/             # App configuration (Supabase keys, constants)
│   ├── models/             # Shared domain models (User, StudentDetails, AlumniDetails)
│   ├── routing/            # App-wide navigation with Go Router
│   └── theme/              # UI theming and Material Design 3 setup
├── features/               # Feature modules
│   ├── auth/              # Authentication (login, signup, session management)
│   ├── dashboard/         # Role-based dashboards (Student, Alumni, Admin)
│   ├── mentorship/        # Mentorship booking and management
│   ├── webinars/          # Webinar hosting and attendance
│   ├── referrals/         # Job referral system
│   ├── chat/              # Real-time messaging
│   ├── profile/           # User profile management
│   └── notifications/     # Notification system
└── main.dart              # App entry point with DI setup
```

### Each Feature Module Structure
```
feature/
├── data/
│   ├── datasources/       # API calls and local storage
│   ├── models/           # Data transfer objects
│   └── repositories/     # Repository implementations
├── domain/
│   ├── entities/         # Business objects
│   ├── repositories/     # Repository interfaces
│   └── usecases/         # Business logic
└── presentation/
    ├── bloc/             # BLoC state management
    ├── pages/            # Screen widgets
    └── widgets/          # Reusable UI components
```

## Technology Stack

- **Frontend**: Flutter 3.0+ with Material Design 3
- **State Management**: Flutter BLoC pattern with Equatable for event/state comparison
- **Backend**: Supabase (PostgreSQL) with Row Level Security
- **Navigation**: Go Router for declarative routing
- **Local Storage**: Hive for caching and offline support
- **HTTP Client**: Dio for API communication
- **UI**: Google Fonts (Plus Jakarta Sans), Cached Network Image for optimization

## Database Schema

Key database tables and relationships:
- **users**: Core user table with role-based access (student/alumni/admin)
- **studentdetails** & **alumnidetails**: Role-specific user information
- **mentorship_sessions** & **mentorship_bookings**: Mentorship system
- **webinars** & **webinar_registrations**: Webinar management
- **referrals**: Job referral tracking
- **chat_messages**: Real-time messaging
- **notifications**: User notification system
- **transactions**: Payment and fee tracking
- **reviews_feedback**: Rating and feedback system

## State Management Pattern

The app uses BLoC pattern consistently:
- Events represent user actions or external triggers
- States represent UI states (loading, success, error, etc.)
- BLoCs contain business logic and emit state changes
- Repositories abstract data access from BLoCs

### Example BLoC Structure
```dart
// Events extend Equatable for comparison
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// States represent UI state
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

// BLoC handles events and emits states
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  
  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
  }
}
```

## Configuration & Environment

### Supabase Configuration
- Update `lib/core/config/app_config.dart` with your Supabase credentials
- Service role key is included (marked as secret) - never expose in client code
- Database URL and anon key are configured for development

### App Configuration Constants
- API timeouts, retry logic, and pagination settings
- File upload constraints and allowed image types
- Platform fee percentages for revenue model

## Key Development Guidelines

### Navigation
- Use context-based navigation: `context.go('/path')`
- All routes are defined in `lib/core/routing/app_router.dart`
- Parameterized routes use path parameters: `/chat/:userId`

### Theme & UI
- Material Design 3 with custom color scheme
- Plus Jakarta Sans font family throughout
- Dark and light theme support with automatic switching
- Consistent card styling and button themes

### Error Handling
- Repository pattern abstracts error handling from BLoCs
- BLoCs emit error states for UI to handle
- Network errors are caught and converted to user-friendly messages

### Dependency Injection
- Repository providers at app root level
- BLoC providers created per feature
- Services injected through constructor parameters

## Role-Based Access

The app supports three user roles:
- **Students**: Book mentorship, join webinars, request referrals
- **Alumni**: Host webinars, provide mentorship, give referrals
- **Admin**: Platform management, user verification, analytics

Dashboard routing and UI adapts based on authenticated user role.

## Testing Strategy

- Unit tests for BLoCs and repositories
- Widget tests for UI components
- Integration tests for user flows
- Mock repositories for isolated testing

## Authentication Persistence

### Problem Solved
The app was automatically signing out users when closed/reopened. This has been fixed with a comprehensive authentication persistence system.

### Implementation
- **Local Storage**: User sessions are saved to SharedPreferences via `AuthLocalDataSource`
- **Session Restoration**: On app startup, `AuthBloc` automatically calls `AuthRestoreRequested()`
- **Multi-layer Check**: The system checks Supabase session first, then local storage as fallback
- **Token Expiration**: Expired tokens are automatically cleared from local storage
- **Graceful Degradation**: If remote auth fails, valid local sessions are used

### Key Components
- `AuthWrapper`: Handles auth state initialization and debugging
- `AuthLocalDataSource`: Manages persistent session storage
- `AuthRepositoryImpl.getCurrentUser()`: Prioritizes Supabase session over local storage
- `AuthBloc.AuthRestoreRequested`: Automatic session restoration on app start
- `AppRouter.createRouter()`: Creates router with authentication state listening
- `GoRouterRefreshStream`: Listens to auth state changes and triggers route refreshes

### Debug Authentication Issues
```dart
// Check if user is saved locally
final hasUser = await authRepository.localDataSource.hasAuthUser();

// Get saved user details
final user = await authRepository.localDataSource.getAuthUser();
if (user != null) {
  print('User: ${user.user.email}');
  print('Expires: ${user.expiresAt}');
  print('Is Expired: ${user.isExpired}');
}

// Test current user retrieval
final currentUser = await authRepository.getCurrentUser();
```

### Authentication-Based Routing
The app now automatically redirects users based on their authentication state:

**Authenticated Users:**
- Redirected to role-specific dashboard (student/alumni/admin)
- Cannot access login/signup pages
- Protected routes are accessible

**Unauthenticated Users:**
- Can access home, login, signup, onboarding pages
- Redirected to login when accessing protected routes
- Protected routes: dashboards, mentorship, webinars, referrals, chat, profile, notifications

**Implementation Details:**
- `GoRouter` listens to `AuthBloc` stream via `GoRouterRefreshStream`
- Route redirects happen automatically when auth state changes
- Loading page shown during authentication restoration
- Comprehensive redirect logic handles all edge cases

## UI Fixes & Improvements

### Image Loading Issues Fixed
- **Problem**: External image URLs (Google images) were failing to load and breaking UI
- **Solution**: Replaced with avatar placeholders and proper error handling
- **Implementation**: 
  - `MentorCard` and `EventCard` now use optional imageUrl parameter
  - Fallback to gradient avatars with initials for mentors
  - Icon placeholders for events when images fail
  - Proper error boundaries for network images

### Student Dashboard Improvements
- Fixed AuthBloc import issues with proper aliasing
- Removed problematic external image URLs
- Added beautiful gradient avatar placeholders with initials
- Improved mentor card layout and error handling
- Fixed navigation routes (alumni page fallback to profile)

### Mentorship Page Fixes
- Added proper back button navigation with fallback
- Improved AppBar with tooltip for create button
- Better error handling and UI consistency

### Reusable UI Components
- `LoadingWidget`: Consistent loading indicators across app
- `ImagePlaceholder`: Reusable avatar and icon placeholders
- Proper gradient backgrounds for user avatars
- Consistent color scheme and sizing

## Navigation Best Practices

### Go Router Consistency
- **Always use Go Router**: Use `context.go()` and `context.pop()` instead of `Navigator.push()`
- **Safe back navigation**: Check `context.canPop()` before calling `context.pop()`
- **Fallback navigation**: If cannot pop, navigate to home with `context.go('/')`

### Common Navigation Patterns
```dart
// Safe back navigation
IconButton(
  onPressed: () {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  },
  icon: Icon(Icons.arrow_back),
)

// Navigate to specific route
ElevatedButton(
  onPressed: () => context.go('/login'),
  child: Text('Login'),
)
```

### Debugging Navigation Issues
Use the `debug_navigation.dart` helper:
```dart
// Log current navigation state
context.debugNavigation();

// Safe back navigation with logging
context.safeGoBack();
```

## Revenue Model Integration

The platform includes transaction tracking for:
- Referral fees (10% of platform fee)
- Webinar fees
- Mentorship session fees
- Platform charges (5% fee)

Transaction records are maintained for accounting and analytics.
