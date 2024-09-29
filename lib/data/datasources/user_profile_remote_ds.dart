import 'package:bioscope/core/interfaces/user_profile_datasource.dart';
import 'package:bioscope/data/models/user_profile_model.dart';

class UserProfileRemoteDs implements UserProfileDataSource {
  // This is a mock implementation. In a real scenario, this would interact with an API.

  UserProfileModel? _userProfile;

  @override
  Future<void> initialize() async {
    // No initialization needed for mock
  }

  @override
  Future<UserProfileModel?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _userProfile?.id == id ? _userProfile : null;
  }

  @override
  Future<void> create(UserProfileModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _userProfile = item;
  }

  @override
  Future<void> update(UserProfileModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_userProfile?.id == item.id) {
      _userProfile = item;
    }
  }

  @override
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_userProfile?.id == id) {
      _userProfile = null;
    }
  }

  @override
  Stream<UserProfileModel?> watchById(String id) {
    return Stream.fromFuture(getById(id));
  }

  @override
  void setupRealtimeListeners(Function(List<UserProfileModel>) onDataChanged) {
    // No implementation needed for mock
  }
}
