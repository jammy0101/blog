import 'package:blog/core/theme/theme.dart';
import 'package:blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'init_dependencies.dart';

// AuthRemoteDataSource → calls Supabase, can throw ServerException.
// AuthRepository (interface) → the contract your app depends on.
// AuthRepositoryImpl → converts exceptions to Failure, returns Either.
// UI → calls repository only, matches on Either to show success/error.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
   runApp(
       MultiBlocProvider(
         providers: [
           BlocProvider(
             create: (_) => serviceLocater<AuthBloc>(),
           ),
         ],
         child: const MyApp(),
       ),
   );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.dartThemeMode,
      home: LoginPage(),
    );
  }
}
