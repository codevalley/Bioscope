import '../../domain/datasources/local_user_data_source.dart';
import '../../domain/entities/user.dart';
import 'user_profile_database.dart';

class LocalUserDataSourceImpl implements LocalUserDataSource {
  final UserProfileDatabase database;

  LocalUserDataSourceImpl({required this.database});

  @override
  Future<void> saveUser(User user) async {
    await database.insertUser(user);
  }

  @override
  Future<User?> getUser() async {
    return await database.getUser();
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    final user = await getUser();
    return user != null;
  }
}
