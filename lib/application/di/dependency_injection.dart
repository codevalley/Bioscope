import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/interfaces/data_source.dart';
import '../../data/datasources/user_profile_sqlite_ds.dart';
import '../../data/datasources/food_entry_sqlite_ds.dart';
import '../../data/datasources/food_entry_supabase_ds.dart';
import '../../data/datasources/user_profile_supabase_ds.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/food_entry_repository_impl.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../domain/repositories/food_entry_repository.dart';
import '../../data/models/user_profile_model.dart';
import '../../data/models/food_entry_model.dart';
import 'package:sqflite/sqflite.dart';
import '../../config/supabase_config.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  // Supabase client
  final supabaseClient = Supabase.instance.client;
  getIt.registerLazySingleton<SupabaseClient>(() => supabaseClient);

  // Data Sources
  if (useSupabase) {
    getIt.registerLazySingleton<DataSource<UserProfileModel>>(
        () => UserProfileSupabaseDs(getIt<SupabaseClient>()));
    getIt.registerLazySingleton<DataSource<FoodEntryModel>>(
        () => FoodEntrySupabaseDs(getIt<SupabaseClient>()));
  } else {
    // SQLite setup (assuming you still want to keep this as an option)
    final database = await openDatabase('app_database.db', version: 1);
    getIt.registerSingleton<Database>(database);
    getIt.registerLazySingleton<DataSource<UserProfileModel>>(
        () => UserProfileSqliteDs(getIt<Database>()));
    getIt.registerLazySingleton<DataSource<FoodEntryModel>>(
        () => FoodEntrySqliteDs(getIt<Database>()));
  }

  // Repositories
  getIt.registerLazySingleton<IUserProfileRepository>(
    () => UserRepositoryImpl(getIt<DataSource<UserProfileModel>>()),
  );
  getIt.registerLazySingleton<IFoodEntryRepository>(
    () => FoodEntryRepositoryImpl(getIt<DataSource<FoodEntryModel>>()),
  );

  // Initialize data sources
  await getIt<DataSource<UserProfileModel>>().initialize();
  await getIt<DataSource<FoodEntryModel>>().initialize();
}

// Flag to determine which data source to use
const bool useSupabase = true; // Set this to false to use SQLite