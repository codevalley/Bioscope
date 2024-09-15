import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/datasources/local_user_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final LocalUserDataSource localDataSource;

  UserRepositoryImpl({required this.localDataSource});

  @override
  Future<void> saveUser(User user) async {
    await localDataSource.saveUser(user);
  }

  @override
  Future<User?> getUser() async {
    return await localDataSource.getUser();
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return await localDataSource.isOnboardingCompleted();
  }
}
