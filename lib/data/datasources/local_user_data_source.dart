import '../models/user_model.dart';

abstract class LocalUserDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getLastCachedUser();
}
