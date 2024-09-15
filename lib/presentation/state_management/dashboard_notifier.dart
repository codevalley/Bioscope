import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bioscope/domain/entities/food_entry.dart';
import 'package:bioscope/domain/repositories/food_entry_repository.dart';
import 'package:bioscope/domain/repositories/user_repository.dart';
import 'package:bioscope/presentation/providers/providers.dart';
import 'package:bioscope/utils/date_formatter.dart';

class DashboardState {
  final String greeting;
  final String dateInfo;
  final int caloriesConsumed;
  final int caloriesRemaining;
  final List<FoodEntry> recentMeals;
  final String userName;
  final int dailyCalorieGoal;

  DashboardState({
    required this.greeting,
    required this.dateInfo,
    required this.caloriesConsumed,
    required this.caloriesRemaining,
    required this.recentMeals,
    required this.userName,
    required this.dailyCalorieGoal,
  });
}

final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final foodRepository = ref.watch(foodEntryRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  return DashboardNotifier(foodRepository, userRepository);
});

class DashboardNotifier extends StateNotifier<DashboardState> {
  final FoodEntryRepository _foodRepository;
  final UserRepository _userRepository;

  DashboardNotifier(this._foodRepository, this._userRepository)
      : super(DashboardState(
          greeting: "Hello",
          dateInfo: "",
          caloriesConsumed: 0,
          caloriesRemaining: 0,
          recentMeals: [],
          userName: "",
          dailyCalorieGoal: 0,
        )) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _foodRepository.initialize();
    await _loadUserData();
    await _loadFoodEntries();
    _foodRepository.watchAllFoodEntries().listen(_updateState);
  }

  Future<void> _loadUserData() async {
    final user = await _userRepository.getUser();
    if (user != null) {
      state = DashboardState(
        greeting: state.greeting,
        dateInfo: state.dateInfo,
        caloriesConsumed: state.caloriesConsumed,
        caloriesRemaining: user.dailyCalorieGoal - state.caloriesConsumed,
        recentMeals: state.recentMeals,
        userName: user.name,
        dailyCalorieGoal: user.dailyCalorieGoal,
      );
    }
  }

  Future<void> _loadFoodEntries() async {
    final entries = await _foodRepository.getAllFoodEntries();
    _updateState(entries);
  }

  void _updateState(List<FoodEntry> entries) {
    final caloriesConsumed =
        entries.fold(0, (sum, entry) => sum + (entry.calories ?? 0));
    final greetingInfo = _getGreetingInfo();

    state = DashboardState(
      greeting: greetingInfo.greeting,
      dateInfo: greetingInfo.dateInfo,
      caloriesConsumed: caloriesConsumed,
      caloriesRemaining: state.dailyCalorieGoal - caloriesConsumed,
      recentMeals: entries.take(5).toList(),
      userName: state.userName,
      dailyCalorieGoal: state.dailyCalorieGoal,
    );
  }

  GreetingInfo _getGreetingInfo() {
    final now = DateTime.now();
    final hour = now.hour;
    final greeting = hour < 12
        ? "Good Morning"
        : (hour < 17 ? "Good Afternoon" : "Good Evening");
    final dateInfo = DateFormatter.formatGreetingDate(now);
    return GreetingInfo(
        greeting: "$greeting, ${state.userName}", dateInfo: dateInfo);
  }

  Future<void> addFoodEntry(FoodEntry entry) async {
    await _foodRepository.addFoodEntry(entry);
  }

  Future<void> refreshUserData() async {
    await _loadUserData();
    await _loadFoodEntries();
  }
}

class GreetingInfo {
  final String greeting;
  final String dateInfo;

  GreetingInfo({required this.greeting, required this.dateInfo});
}
