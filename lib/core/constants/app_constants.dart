class AppConstants {
  /// Override at build time: --dart-define=API_BASE_URL=https://api.example.com/api
  /// (10.0.2.2 = host machine from the Android emulator)
  static const apiBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:3000/api');
  /// Public values (anon key is designed to be public; RLS protects data).
  /// --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 20);
}
