# Revised Supabase Integration Plan

## 1. Maintain Clean Architecture

### Domain Layer

The domain layer should remain completely unaware of Supabase or any other concrete implementations. Let's revise the `IUserProfileRepository` interface:

```dart
abstract class IUserProfileRepository {
  Future<UserProfile?> getUserProfile();
  Future<void> saveUserProfile(UserProfile userProfile);
  Future<void> updateUserProfile(UserProfile userProfile);
  Future<bool> isOnboardingCompleted();
}
```

### Data Layer

The data layer will contain the Supabase-specific implementations, but these should not leak into the domain layer.

#### UserProfileRepositoryImpl

```dart
class UserProfileRepositoryImpl implements IUserProfileRepository {
  final DataSource<UserProfileModel> _dataSource;
  final IAuthService _authService;

  UserProfileRepositoryImpl(this._dataSource, this._authService);

  @override
  Future<UserProfile?> getUserProfile() async {
    final userId = await _authService.getCurrentUserId();
    if (userId == null) return null;
    final userProfileModel = await _dataSource.getById(userId);
    return userProfileModel?.toDomain();
  }

  @override
  Future<void> saveUserProfile(UserProfile userProfile) async {
    final userId = await _authService.getCurrentUserId();
    if (userId == null) throw Exception('User not authenticated');
    await _dataSource.create(UserProfileModel.fromDomain(userProfile)..id = userId);
  }

  @override
  Future<void> updateUserProfile(UserProfile userProfile) async {
    await _dataSource.update(UserProfileModel.fromDomain(userProfile));
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    final profile = await getUserProfile();
    final isAnonymous = await _authService.isAnonymous();
    return profile != null && !isAnonymous;
  }
}
```

#### IAuthService

Create an interface for the auth service in the domain layer:

```dart
abstract class IAuthService {
  Future<String?> getCurrentUserId();
  Future<bool> isAnonymous();
  Future<void> signInAnonymously();
  Future<void> signUp(String email, String password);
  Future<void> signIn(String email, String password);
  Future<void> signOut();
}
```

#### SupabaseAuthService

Implement the `IAuthService` interface with Supabase-specific logic:

```dart
class SupabaseAuthService implements IAuthService {
  final SupabaseClient _supabaseClient;

  SupabaseAuthService(this._supabaseClient);

  @override
  Future<String?> getCurrentUserId() async {
    return _supabaseClient.auth.currentUser?.id;
  }

  @override
  Future<bool> isAnonymous() async {
    return _supabaseClient.auth.currentUser?.appMetadata['provider'] == 'anonymous';
  }

  // Implement other methods...
}
```

#### SupabaseDataSource

```dart
class SupabaseDataSource<T> implements DataSource<T> {
  final SupabaseClient _supabaseClient;
  final String _tableName;
  final T Function(Map<String, dynamic>) _fromJson;
  final Map<String, dynamic> Function(T) _toJson;

  SupabaseDataSource(this._supabaseClient, this._tableName, this._fromJson, this._toJson);

  @override
  Future<void> create(T item) async {
    await _supabaseClient.from(_tableName).insert(_toJson(item));
  }

  @override
  Future<T?> getById(String id) async {
    final response = await _supabaseClient
        .from(_tableName)
        .select()
        .eq('id', id)
        .single()
        .execute();
    if (response.data != null) {
      return _fromJson(response.data);
    }
    return null;
  }

  // Implement other methods...
}
```

## 2. Update Dependency Injection

```dart
final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final supabase = await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_ANON_KEY',
  );

  getIt.registerLazySingleton<SupabaseClient>(() => supabase.client);

  getIt.registerLazySingleton<IAuthService>(
    () => SupabaseAuthService(getIt<SupabaseClient>()),
  );

  getIt.registerLazySingleton<DataSource<UserProfileModel>>(
    () => SupabaseDataSource<UserProfileModel>(
      getIt<SupabaseClient>(),
      'user_profiles',
      UserProfileModel.fromJson,
      (model) => model.toJson(),
    ),
  );

  getIt.registerLazySingleton<IUserProfileRepository>(
    () => UserProfileRepositoryImpl(
      getIt<DataSource<UserProfileModel>>(),
      getIt<IAuthService>(),
    ),
  );

  // Register other dependencies...
}
```

## 3. Update Presentation Layer

### OnboardingNotifier

```dart
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final IUserProfileRepository _userProfileRepository;
  final IAuthService _authService;

  OnboardingNotifier(this._userProfileRepository, this._authService)
      : super(const OnboardingState.initial());

  Future<void> completeOnboarding(String name, String email, String password, int dailyCalorieGoal) async {
    state = const OnboardingState.inProgress();

    try {
      if (await _authService.isAnonymous()) {
        await _authService.signUp(email, password);
      }

      final userId = await _authService.getCurrentUserId();
      if (userId == null) throw Exception('Failed to get user ID');

      final userProfile = UserProfile(
        id: userId,
        name: name,
        email: email,
        dailyCalorieGoal: dailyCalorieGoal,
      );
      await _userProfileRepository.saveUserProfile(userProfile);

      state = const OnboardingState.complete();
    } catch (e) {
      state = OnboardingState.error(e.toString());
    }
  }
}
```

### DashboardNotifier

```dart
class DashboardNotifier extends StateNotifier<DashboardState> {
  final IUserProfileRepository _userProfileRepository;
  final IFoodEntryRepository _foodEntryRepository;
  final IAuthService _authService;

  DashboardNotifier(this._userProfileRepository, this._foodEntryRepository, this._authService)
      : super(DashboardState.initial()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    final userId = await _authService.getCurrentUserId();
    if (userId == null) return;

    final userProfile = await _userProfileRepository.getUserProfile();
    final recentMeals = await _foodEntryRepository.getRecentFoodEntries();
    final totalCalories = await _foodEntryRepository.getTotalCaloriesConsumed();

    if (userProfile != null) {
      state = DashboardState(
        greeting: _getGreeting(),
        caloriesConsumed: totalCalories,
        caloriesRemaining: userProfile.dailyCalorieGoal - totalCalories,
        recentMeals: recentMeals,
        userName: userProfile.name,
        dailyCalorieGoal: userProfile.dailyCalorieGoal,
      );
    }
  }

  // ... other methods ...
}
```

## Addressing Your Specific Questions

1. The `UserProfileRepository` no longer directly accesses Supabase or concrete AuthService implementations. It now depends on abstractions (`DataSource` and `IAuthService`).

2. The plan has been revised to ensure that the domain layer remains decoupled from specific implementations.

3. The Supabase-specific `DataSource` is used in the data layer to interact with Supabase tables. It's injected into the repository implementations but not exposed to the domain or presentation layers.

This revised plan maintains clean architecture by:

- Keeping the domain layer free from external dependencies.
- Using dependency inversion to depend on abstractions rather than concretions.
- Isolating Supabase-specific code in the data layer.
- Ensuring that the presentation layer interacts only with interfaces defined in the domain layer.