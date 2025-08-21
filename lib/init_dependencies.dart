import 'package:blog/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:blog/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog/features/auth/domain/repository/auth_repository.dart';
import 'package:blog/features/auth/domain/usecases/user_login.dart';
import 'package:blog/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/secrets/app_secrets.dart';

final serviceLocater = GetIt.instance;

Future<void> initDependencies() async {

  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocater.registerLazySingleton(() => supabase.client);
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
    ..registerFactory(
    () => UserSignUp(authRepository: serviceLocater()),
  )..registerFactory(
    () => UserLogin(authRepository: serviceLocater()),
  )
    //This is the bloc
    ..registerLazySingleton(
    () => AuthBloc(userSignUp: serviceLocater(), userLogin: serviceLocater()),
  );
}
