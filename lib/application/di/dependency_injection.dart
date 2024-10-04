import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/user_profile_sqlite_ds.dart';
import '../../data/datasources/food_entry_sqlite_ds.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../data/repositories/food_entry_repository_impl.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../domain/repositories/food_entry_repository.dart';
import '../../domain/repositories/daily_goals_repository.dart';
import 'package:sqflite/sqflite.dart';
import '../../config/supabase_config.dart';
import '../../domain/services/auth_service.dart';
import '../../data/services/supabase_auth_service.dart';
import "../../data/datasources/food_entry_supabase_ds.dart";
import "../../data/datasources/user_profile_supabase_ds.dart";
import "../../data/datasources/daily_goals_supabase_ds.dart";
import "../../data/repositories/daily_goals_repository_impl.dart";
import "../../data/datasources/daily_goals_sqlite_ds.dart";
import '../../core/interfaces/daily_goals_datasource.dart';
import '../../core/interfaces/food_entry_datasource.dart';
import '../../core/interfaces/user_profile_datasource.dart';

/// Global instance of GetIt for dependency injection.
final getIt = GetIt.instance;

/// Flag to determine which data source to use.
/// Set this to false to use SQLite instead of Supabase.
const bool useSupabase = true;

/// Sets up all dependencies for the application.
///
/// This function initializes Supabase, registers all necessary services,
/// data sources, and repositories with GetIt for dependency injection.
Future<void> setupDependencies() async {
  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  // Register Supabase client
  final supabaseClient = Supabase.instance.client;
  getIt.registerLazySingleton<SupabaseClient>(() => supabaseClient);

  // Register Auth Service
  getIt.registerLazySingleton<IAuthService>(
    () => SupabaseAuthService(getIt<SupabaseClient>()),
  );

  // Register Data Sources
  if (useSupabase) {
    _registerSupabaseDataSources();
  } else {
    await _registerSqliteDataSources();
  }

  // Register Repositories
  _registerRepositories();

  // Initialize data sources
  await getIt<DailyGoalsDataSource>().initialize();
  await getIt<UserProfileDataSource>().initialize();
  await getIt<FoodEntryDataSource>().initialize();
}

/// Registers Supabase-specific data sources.
void _registerSupabaseDataSources() {
  getIt.registerLazySingleton<UserProfileDataSource>(
    () => UserProfileSupabaseDs(getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<FoodEntryDataSource>(
    () => FoodEntrySupabaseDs(getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<DailyGoalsDataSource>(
    () => DailyGoalsSupabaseDs(getIt<SupabaseClient>()),
  );
}

/// Registers SQLite-specific data sources.
Future<void> _registerSqliteDataSources() async {
  final database = await openDatabase('app_database.db', version: 1);
  getIt.registerSingleton<Database>(database);

  getIt.registerLazySingleton<UserProfileDataSource>(
    () => UserProfileSqliteDs(getIt<Database>()),
  );
  getIt.registerLazySingleton<FoodEntryDataSource>(
    () => FoodEntrySqliteDs(getIt<Database>()),
  );
  getIt.registerLazySingleton<DailyGoalsDataSource>(
    () => DailyGoalsSqliteDs(getIt<Database>()),
  );
}

/// Registers repositories.
void _registerRepositories() {
  getIt.registerLazySingleton<IUserProfileRepository>(
    () => UserProfileRepositoryImpl(
      getIt<UserProfileDataSource>(),
      getIt<IAuthService>(),
    ),
  );
  getIt.registerLazySingleton<IFoodEntryRepository>(
    () => FoodEntryRepositoryImpl(
      getIt<FoodEntryDataSource>(),
    ),
  );
  getIt.registerLazySingleton<IDailyGoalsRepository>(
    () => DailyGoalsRepositoryImpl(getIt<DailyGoalsDataSource>()),
  );
}
