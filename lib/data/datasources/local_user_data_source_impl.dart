import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/datasources/local_user_data_source.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

class LocalUserDataSourceImpl implements LocalUserDataSource {
  final SharedPreferences sharedPreferences;

  LocalUserDataSourceImpl({required this.sharedPreferences});

  static const String _userKey = 'user_data';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  @override
  Future<void> saveUser(User user) async {
    final userModel = UserModel.fromEntity(user);
    final userData = json.encode(userModel.toJson());
    await sharedPreferences.setString(_userKey, userData);
    await sharedPreferences.setBool(_onboardingCompletedKey, true);
  }

  @override
  Future<User?> getUser() async {
    final userData = sharedPreferences.getString(_userKey);
    if (userData != null) {
      final userMap = json.decode(userData) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return sharedPreferences.getBool(_onboardingCompletedKey) ?? false;
  }
}
