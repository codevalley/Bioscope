import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bioscope/domain/entities/food_entry.dart';
import 'package:bioscope/domain/repositories/food_entry_repository.dart';
import 'package:bioscope/presentation/providers/providers.dart';
import 'package:bioscope/utils/date_formatter.dart';

class DashboardState {
  final String greeting;
  final String dateInfo;
  final int caloriesConsumed;
  final int caloriesRemaining;
  final List<FoodEntry> recentMeals;

  DashboardState({
    required this.greeting,
    required this.dateInfo,
    required this.caloriesConsumed,
    required this.caloriesRemaining,
    required this.recentMeals,
  });
}

final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final repository = ref.watch(foodEntryRepositoryProvider);
  return DashboardNotifier(repository);
});

class DashboardNotifier extends StateNotifier<DashboardState> {
  final FoodEntryRepository _repository;

  DashboardNotifier(this._repository)
      : super(DashboardState(
          greeting: "Hello",
          dateInfo: "",
          caloriesConsumed: 0,
          caloriesRemaining: 2000, // Default value, will be updated
          recentMeals: [],
        )) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _repository.initialize();
    await _loadFoodEntries();
    _repository.watchAllFoodEntries().listen(_updateState);
  }

  Future<void> _loadFoodEntries() async {
    final entries = await _repository.getAllFoodEntries();
    _updateState(entries);
  }

  void _updateState(List<FoodEntry> entries) {
    final caloriesConsumed =
        entries.fold(0, (sum, entry) => sum + (entry.calories ?? 0));
    final totalCalories = caloriesConsumed + state.caloriesRemaining;
    final greetingInfo = _getGreetingInfo();

    state = DashboardState(
      greeting: greetingInfo.greeting,
      dateInfo: greetingInfo.dateInfo,
      caloriesConsumed: caloriesConsumed,
      caloriesRemaining: totalCalories - caloriesConsumed,
      recentMeals: entries.take(5).toList(),
    );
  }

  GreetingInfo _getGreetingInfo() {
    final now = DateTime.now();
    final hour = now.hour;
    final greeting = hour < 12
        ? "Good Morning"
        : (hour < 17 ? "Good Afternoon" : "Good Evening");
    final dateInfo = DateFormatter.formatGreetingDate(now);
    return GreetingInfo(greeting: greeting, dateInfo: dateInfo);
  }

  Future<void> addFoodEntry(FoodEntry entry) async {
    await _repository.addFoodEntry(entry);
  }
}

class GreetingInfo {
  final String greeting;
  final String dateInfo;

  GreetingInfo({required this.greeting, required this.dateInfo});
}
