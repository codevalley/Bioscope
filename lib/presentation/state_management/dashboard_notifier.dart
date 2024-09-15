import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bioscope/domain/entities/food_entry.dart';
import 'package:bioscope/domain/repositories/food_entry_repository.dart';
import 'package:bioscope/presentation/providers/providers.dart';

class DashboardState {
  final String greeting;
  final int caloriesConsumed;
  final int caloriesRemaining;
  final List<FoodEntry> recentMeals;

  DashboardState({
    required this.greeting,
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
          caloriesConsumed: 0,
          caloriesRemaining: 2000,
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
    state = DashboardState(
      greeting: _getGreeting(),
      caloriesConsumed: caloriesConsumed,
      caloriesRemaining:
          2000 - caloriesConsumed, // Assuming 2000 is the daily goal
      recentMeals: entries.take(5).toList(),
    );
  }

  String _getGreeting() {
    final now = DateTime.now();
    final hour = now.hour;
    final dayName = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ][now.weekday - 1];
    final monthName = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ][now.month - 1];
    final greeting = hour < 12
        ? "Good Morning"
        : (hour < 17 ? "Good Afternoon" : "Good Evening");
    return "$greeting\n$dayName, ${now.day} $monthName";
  }

  Future<void> addFoodEntry(FoodEntry entry) async {
    await _repository.addFoodEntry(entry);
  }
}
