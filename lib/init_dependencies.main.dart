
part  of 'init_dependencies.dart';


final serviceLocater = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  //Hive.defaultDictionery =  (await getApplicationDocumentsDirectory()).path;
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  final blogBox = await Hive.openBox('blogs');
  serviceLocater.registerLazySingleton(() => supabase.client);
  serviceLocater.registerLazySingleton(() => AuthUserCubit());
  //serviceLocater.registerLazySingleton(() => Hive.box(name : 'blogs'));
  serviceLocater.registerLazySingleton(() => blogBox);
  serviceLocater.registerLazySingleton(
        () => Logout(serviceLocater<AuthRepository>()),
  );

  serviceLocater.registerLazySingleton(() => InternetConnection());
  serviceLocater.registerFactory<ConnectionChecker>(
        () => ConnectionCheckerImpl(serviceLocater()),
  );
}

void _initAuth() {
  //this is the datasource
  serviceLocater
    ..registerFactory<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(serviceLocater()),
    )
  //this is the repository
    ..registerFactory<AuthRepository>(
          () => AuthRepositoryImpl(serviceLocater(), serviceLocater()),
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
        logout: serviceLocater(),
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
          () => BlogRepositoryImpl(
        serviceLocater(),
        serviceLocater(),
        serviceLocater(),
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
          () => BlogLocalDataSourceImpl(serviceLocater()),
    )
  //Usecase
    ..registerFactory(() => UploadBlog(serviceLocater()))
  //UseCase
    ..registerFactory(() => GetAllBlogs(serviceLocater()))
  //Bloc
    ..registerLazySingleton(
          () =>
          BlogBloc(uploadBlog: serviceLocater(), getAllBlogs: serviceLocater()),
    );
}
