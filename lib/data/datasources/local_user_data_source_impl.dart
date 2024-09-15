import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/datasources/local_user_data_source.dart';
import '../../domain/entities/user.dart';

class LocalUserDataSourceImpl implements LocalUserDataSource {
  final SharedPreferences sharedPreferences;

  LocalUserDataSourceImpl({required this.sharedPreferences});

  static const String _userKey = 'user';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  @override
  Future<void> saveUser(User user) async {
    await sharedPreferences.setString(_userKey, json.encode(user.toJson()));
    await sharedPreferences.setBool(_onboardingCompletedKey, true);
  }

  @override
  Future<User?> getUser() async {
    final userData = sharedPreferences.getString(_userKey);
    if (userData != null) {
      return User.fromJson(json.decode(userData));
    }
    return null;
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return sharedPreferences.getBool(_onboardingCompletedKey) ?? false;
  }
}
