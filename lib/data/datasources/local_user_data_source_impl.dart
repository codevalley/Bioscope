import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'local_user_data_source.dart';

class LocalUserDataSourceImpl implements LocalUserDataSource {
  final SharedPreferences sharedPreferences;

  LocalUserDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(
        'CACHED_USER', json.encode(user.toJson()));
  }

  @override
  Future<UserModel?> getLastCachedUser() async {
    final jsonString = sharedPreferences.getString('CACHED_USER');
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }
}
