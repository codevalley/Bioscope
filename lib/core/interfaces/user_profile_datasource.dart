import 'package:bioscope/core/interfaces/data_source.dart';
import 'package:bioscope/data/models/user_profile_model.dart';

/// Defines the interface for accessing and manipulating user profile data.
///
/// This interface extends the generic [DataSource] interface, specializing it
/// for [UserProfileModel] operations. It inherits all the standard CRUD operations
/// from [DataSource] without adding any additional methods specific to user profiles.
abstract class UserProfileDataSource extends DataSource<UserProfileModel> {}
