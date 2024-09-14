import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/local_user_data_source.dart';
import '../../data/datasources/local_user_data_source_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Data sources
  getIt.registerLazySingleton<LocalUserDataSource>(
    () => LocalUserDataSourceImpl(sharedPreferences: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(localDataSource: getIt()),
  );
}
