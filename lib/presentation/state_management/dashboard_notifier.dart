import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/food_entry_repository.dart';
import '../../data/repositories/food_entry_repository_impl.dart'; // Add this import
import '../../domain/entities/food_entry.dart';

class DashboardState {
  final String greeting;
  final int caloriesConsumed;
  final int caloriesRemaining;
  final List<String> recentMeals;

  DashboardState({
    required this.greeting,
    required this.caloriesConsumed,
    required this.caloriesRemaining,
    required this.recentMeals,
  });

  DashboardState copyWith({
    String? greeting,
    int? caloriesConsumed,
    int? caloriesRemaining,
    List<String>? recentMeals,
  }) {
    return DashboardState(
      greeting: greeting ?? this.greeting,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      caloriesRemaining: caloriesRemaining ?? this.caloriesRemaining,
      recentMeals: recentMeals ?? this.recentMeals,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final FoodEntryRepository _foodEntryRepository;

  DashboardNotifier(this._foodEntryRepository)
      : super(DashboardState(
          greeting: '',
          caloriesConsumed: 0,
          caloriesRemaining: 0,
          recentMeals: [],
        )) {
    _initializeDashboard();
  }

  Future<void> _initializeDashboard() async {
    final caloriesConsumed =
        await _foodEntryRepository.getTotalCaloriesConsumed();
    final recentEntries = await _foodEntryRepository.getRecentFoodEntries();

    state = state.copyWith(
      greeting: _getGreeting(),
      caloriesConsumed: caloriesConsumed,
      caloriesRemaining:
          2000 - caloriesConsumed, // Assuming a 2000 calorie goal
      recentMeals: recentEntries.map((e) => e.name).toList(),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Future<void> addFoodEntry(FoodEntry entry) async {
    await _foodEntryRepository.addFoodEntry(entry);
    await _initializeDashboard(); // Refresh the dashboard data
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final foodEntryRepository = ref.watch(foodEntryRepositoryProvider);
  return DashboardNotifier(foodEntryRepository);
});
