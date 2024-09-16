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
  final database = await openDatabase(
    'app_database.db',
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS user_profiles(
          id TEXT PRIMARY KEY,
          name TEXT,
          age INTEGER,
          height REAL,
          weight REAL,
          gender TEXT,
          dailyCalorieGoal INTEGER
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS food_entries(
          id TEXT PRIMARY KEY,
          name TEXT,
          calories INTEGER,
          date TEXT
        )
      ''');
    },
  );
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
}
