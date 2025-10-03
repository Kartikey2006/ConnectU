import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectu_alumni_platform/core/config/app_config.dart';
import 'package:connectu_alumni_platform/core/routing/app_router.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';
import 'package:connectu_alumni_platform/core/utils/navigation_utils.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart'
    as auth_bloc;
import 'package:connectu_alumni_platform/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:connectu_alumni_platform/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:connectu_alumni_platform/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:connectu_alumni_platform/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:connectu_alumni_platform/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:connectu_alumni_platform/features/profile/data/datasources/profile_remote_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  // Initialize Hive
  await Hive.initFlutter();

  runApp(const ConnectUApp());
}

class ConnectUApp extends StatelessWidget {
  const ConnectUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepositoryImpl>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: AuthRemoteDataSourceImpl(),
            localDataSource: AuthLocalDataSourceImpl(),
          ),
        ),
        RepositoryProvider<ProfileRepositoryImpl>(
          create: (context) => ProfileRepositoryImpl(
            ProfileRemoteDataSource(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          // Create AuthBloc
          final authBloc = auth_bloc.AuthBloc(
            context.read<AuthRepositoryImpl>(),
          );

          // Create Router with AuthBloc
          final router = AppRouter.createRouter(authBloc);

          return MultiBlocProvider(
            providers: [
              BlocProvider<auth_bloc.AuthBloc>.value(
                value: authBloc,
              ),
              BlocProvider<ProfileBloc>(
                create: (context) => ProfileBloc(
                  context.read<ProfileRepositoryImpl>(),
                ),
              ),
            ],
            child: AuthWrapper(
              child: PopScope(
                canPop: false, // We handle all back navigation ourselves
                onPopInvoked: (didPop) async {
                  if (!didPop) {
                    // Handle system back button press
                    final context =
                        router.routerDelegate.navigatorKey.currentContext;
                    if (context != null) {
                      // Use NavigationUtils for consistent back navigation
                      NavigationUtils.safeBack(context);
                    }
                  }
                },
                child: MaterialApp.router(
                  title: 'ConnectU',
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: ThemeMode.dark,
                  routerConfig: router,
                  debugShowCheckedModeBanner: false,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Authentication wrapper to handle session persistence
class AuthWrapper extends StatefulWidget {
  final Widget child;

  const AuthWrapper({super.key, required this.child});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    // Add lifecycle observer
    WidgetsBinding.instance.addObserver(this);

    // Initialize auth restoration after the widget tree is built
    // Use a small delay to allow UI to render first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          context
              .read<auth_bloc.AuthBloc>()
              .add(auth_bloc.AuthRestoreRequested());
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('🔄 App lifecycle changed: $state');

    switch (state) {
      case AppLifecycleState.paused:
        print('⏸️ App paused - saving session');
        // App is going to background, don't clear session
        break;
      case AppLifecycleState.resumed:
        print('▶️ App resumed - checking session');
        // App is coming back to foreground, check if session is still valid
        if (mounted) {
          context
              .read<auth_bloc.AuthBloc>()
              .add(auth_bloc.AuthRestoreRequested());
        }
        break;
      case AppLifecycleState.detached:
        print('🔌 App detached - preserving session');
        // App is being closed, preserve session in local storage
        break;
      case AppLifecycleState.inactive:
        print('⏸️ App inactive');
        break;
      case AppLifecycleState.hidden:
        print('👁️ App hidden');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<auth_bloc.AuthBloc, auth_bloc.AuthState>(
      listener: (context, state) {
        // Handle auth state changes for debugging
        if (state is auth_bloc.Authenticated) {
          debugPrint('🔐 User authenticated: ${state.user.user.email}');
        } else if (state is auth_bloc.Unauthenticated) {
          debugPrint('🔓 User unauthenticated');
        } else if (state is auth_bloc.AuthError) {
          debugPrint('❌ Auth error: ${state.message}');
        }
      },
      child: widget.child,
    );
  }
}
