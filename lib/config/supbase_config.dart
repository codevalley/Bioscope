/// Deprecated: Use SupabaseConfig class instead.
///
/// This class contains hardcoded Supabase configuration values.
/// It is recommended to use environment variables for sensitive information.
@Deprecated('Use SupabaseConfig class with environment variables instead')
class SupabaseConfig {
  /// The URL of the Supabase project.
  ///
  /// This should be replaced with your actual Supabase project URL.
  static const String url = 'YOUR_SUPABASE_PROJECT_URL';

  /// The anonymous key for the Supabase project.
  ///
  /// This should be replaced with your actual Supabase anonymous key.
  static const String anonKey = 'YOUR_SUPABASE_ANON_KEY';
}
