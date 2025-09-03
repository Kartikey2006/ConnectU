import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectu_alumni_platform/core/config/app_config.dart';
import 'package:connectu_alumni_platform/core/routing/app_router.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart';
import 'package:connectu_alumni_platform/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:connectu_alumni_platform/features/auth/data/datasources/auth_remote_datasource.dart';

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
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              context.read<AuthRepositoryImpl>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'ConnectU',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
