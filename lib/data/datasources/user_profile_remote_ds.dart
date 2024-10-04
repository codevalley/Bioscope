import 'package:bioscope/core/interfaces/user_profile_datasource.dart';
import 'package:bioscope/data/models/user_profile_model.dart';

/// Remote API implementation of the [UserProfileDataSource] interface.
///
/// This class provides methods to interact with a remote API for storing and retrieving user profiles.
/// Note: This is currently a mock implementation and should be replaced with actual API calls in production.
class UserProfileRemoteDs implements UserProfileDataSource {
  // This is a mock implementation. In a real scenario, this would interact with an API.

  UserProfileModel? _userProfile;

  /// Initializes the remote data source.
  ///
  /// In a real implementation, this might set up API authentication or other necessary configurations.
  @override
  Future<void> initialize() async {
    // No initialization needed for mock
  }

  /// Retrieves a user profile by its ID from the remote API.
  ///
  /// [id] The unique identifier of the user profile.
  /// Returns a [Future] that completes with the [UserProfileModel] if found, or null otherwise.
  @override
  Future<UserProfileModel?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _userProfile?.id == id ? _userProfile : null;
  }

  /// Creates a new user profile in the remote API.
  ///
  /// [item] The [UserProfileModel] to be created.
  @override
  Future<void> create(UserProfileModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _userProfile = item;
  }

  /// Updates an existing user profile in the remote API.
  ///
  /// [item] The [UserProfileModel] to be updated.
  @override
  Future<void> update(UserProfileModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_userProfile?.id == item.id) {
      _userProfile = item;
    }
  }

  /// Deletes a user profile from the remote API.
  ///
  /// [id] The unique identifier of the user profile to be deleted.
  @override
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_userProfile?.id == id) {
      _userProfile = null;
    }
  }

  /// Provides a stream of a specific user profile by its ID.
  ///
  /// [id] The unique identifier of the user profile to watch.
  /// Returns a [Stream] that emits the updated [UserProfileModel] whenever it changes.
  @override
  Stream<UserProfileModel?> watchById(String id) {
    return Stream.fromFuture(getById(id));
  }

  /// Sets up real-time listeners for data changes.
  ///
  /// This method is not implemented in this mock version.
  @override
  void setupRealtimeListeners(Function(List<UserProfileModel>) onDataChanged) {
    // No implementation needed for mock
  }
}
