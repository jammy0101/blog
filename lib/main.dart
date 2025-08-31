import 'package:blog/core/theme/theme.dart';
import 'package:blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog/features/auth/presentation/pages/login_page.dart';
import 'package:blog/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/common/cubit/app_user/auth_user_cubit.dart';
import 'features/blog/presentation/pages/blog_page.dart';
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
          create: (_) => serviceLocater<AuthUserCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocater<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocater<BlogBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.dartThemeMode,
      home: BlocSelector<AuthUserCubit, AuthUserState, bool>(
        selector: (state) {
          return state is AuthUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if(isLoggedIn){
            return BlogPage();
          }
          return LoginPage();
        },
      ),
    );
  }
}
