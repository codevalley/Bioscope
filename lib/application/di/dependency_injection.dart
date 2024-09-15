import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/local_user_data_source_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/datasources/local_user_data_source.dart';
import '../../domain/repositories/user_repository.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // LocalUserDataSource
  getIt.registerLazySingleton<LocalUserDataSource>(
    () => LocalUserDataSourceImpl(sharedPreferences: getIt()),
  );

  // UserRepository
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(localDataSource: getIt()),
  );
}
