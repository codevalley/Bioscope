import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import '../../data/datasources/user_profile_sqlite_ds.dart';
import '../../data/datasources/food_entry_sqlite_ds.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/food_entry_repository_impl.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../domain/repositories/food_entry_repository.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Database
  final database = await openDatabase('app_database.db', version: 1);
  getIt.registerSingleton<Database>(database);

  // Data Sources
  getIt.registerLazySingleton<UserProfileSqliteDs>(
      () => UserProfileSqliteDs(database));
  getIt.registerLazySingleton<FoodEntrySqliteDs>(
      () => FoodEntrySqliteDs(database));

  // Repositories
  getIt.registerLazySingleton<IUserProfileRepository>(
    () => UserRepositoryImpl(getIt<UserProfileSqliteDs>()),
  );
  getIt.registerLazySingleton<IFoodEntryRepository>(
    () => FoodEntryRepositoryImpl(getIt<FoodEntrySqliteDs>()),
  );

  // Initialize data sources
  await getIt<UserProfileSqliteDs>().initialize();
  await getIt<FoodEntrySqliteDs>().initialize();
}
