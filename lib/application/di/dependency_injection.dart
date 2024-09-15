import 'package:get_it/get_it.dart';
import '../../data/datasources/local_user_data_source_impl.dart';
import '../../data/datasources/user_profile_database.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/datasources/local_user_data_source.dart';
import '../../domain/repositories/user_repository.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // User Profile Database
  getIt.registerLazySingleton(() => UserProfileDatabase.instance);

  // Local User Data Source
  getIt.registerLazySingleton<LocalUserDataSource>(
    () => LocalUserDataSourceImpl(database: getIt()),
  );

  // User Repository
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(localDataSource: getIt()),
  );
}
