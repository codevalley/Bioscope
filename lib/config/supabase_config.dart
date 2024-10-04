import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration class for Supabase-related settings.
///
/// This class uses environment variables loaded from a .env file
/// to provide Supabase configuration details.
class SupabaseConfig {
  /// The URL of the Supabase project.
  ///
  /// This value is read from the 'SUPABASE_URL' environment variable.
  static String get url => dotenv.env['SUPABASE_URL'] ?? '';

  /// The anonymous key for the Supabase project.
  ///
  /// This value is read from the 'SUPABASE_ANON_KEY' environment variable.
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  /// The URL for Supabase storage.
  ///
  /// This value is read from the 'SUPABASE_STORAGE_URL' environment variable.
  static String get storageUrl => dotenv.env['SUPABASE_STORAGE_URL'] ?? '';
}
