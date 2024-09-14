import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local_user_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final LocalUserDataSource localDataSource;

  UserRepositoryImpl({required this.localDataSource});

  @override
  Future<void> saveUser(User user) async {
    final userModel = UserModel(
      id: user.id,
      name: user.name,
      dailyCalorieGoal: user.dailyCalorieGoal,
      dietaryPreferences: user.dietaryPreferences,
    );
    await localDataSource.cacheUser(userModel);
  }

  @override
  Future<User?> getUser() async {
    final userModel = await localDataSource.getLastCachedUser();
    return userModel;
  }
}
