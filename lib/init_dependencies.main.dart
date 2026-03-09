part of 'init_dependencies.dart';
final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));
  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
}

void _initAuth() {
  //Data source
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()),
    )
    // Rebository
    ..registerFactory<AuthRebository>(
      () => AuthRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    // use cases
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    // bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  //Data source
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(serviceLocator()),
    )
    // Rebository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // use cases
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    // bloc
    ..registerLazySingleton(
      () =>
          BlogBloc(uploadBlog: serviceLocator(), getAllBlogs: serviceLocator()),
    );
}
