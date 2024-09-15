import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/user_repository.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/datasources/local_user_data_source_impl.dart';
import '../../domain/datasources/local_user_data_source.dart'; // Add this import

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  getIt.registerLazySingleton<LocalUserDataSource>(
    () => LocalUserDataSourceImpl(sharedPreferences: getIt()),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(localDataSource: getIt()),
  );
}
