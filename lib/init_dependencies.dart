import 'package:blog/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:blog/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog/features/auth/domain/repository/auth_repository.dart';
import 'package:blog/features/auth/domain/usecases/current_user.dart';
import 'package:blog/features/auth/domain/usecases/user_login.dart';
import 'package:blog/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog/features/blog/data/data_source/blog_remote_data_source.dart';
import 'package:blog/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:blog/features/blog/domain/repository/blog_repository.dart';
import 'package:blog/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/common/cubit/app_user/auth_user_cubit.dart';
import 'core/secrets/app_secrets.dart';

final serviceLocater = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocater.registerLazySingleton(() => supabase.client);
  serviceLocater.registerLazySingleton(() => AuthUserCubit());
}

void _initAuth() {
  //this is the datasource
  serviceLocater
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocater()),
    )
    //this is the repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocater()),
    )
    //this is the Use cases
    ..registerFactory(() => UserSignUp(authRepository: serviceLocater()))
    //this is for Login
    ..registerFactory(() => UserLogin(authRepository: serviceLocater()))
    //This is for Current User
    ..registerFactory(() => CurrentUser(serviceLocater()))
    //This is the bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocater(),
        userLogin: serviceLocater(),
        currentUser: serviceLocater(),
        authUserCubit: serviceLocater(),
      ),
    );
}

void _initBlog() {
  serviceLocater
    //DataSource
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocater()),
    )
    //Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(serviceLocater()),
    )
    //Usecase
    ..registerFactory(() => UploadBlog(serviceLocater()))

    //UseCase
  ..registerFactory(() => GetAllBlogs(serviceLocater()))
    //Bloc
    ..registerLazySingleton(() => BlogBloc(

      uploadBlog: serviceLocater(),
      getAllBlogs: serviceLocater(),
    ));
}
