import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bioscope/data/services/nutrition_service.dart';
import 'package:bioscope/domain/entities/nutrition_info.dart';
import 'package:bioscope/domain/repositories/food_entry_repository.dart';
import 'package:bioscope/domain/repositories/daily_goals_repository.dart';
import 'package:bioscope/domain/repositories/user_profile_repository.dart';
import 'package:bioscope/domain/entities/food_entry.dart';
import 'package:bioscope/domain/entities/daily_goals.dart';

/// Base class for all food capture events.
abstract class FoodCaptureEvent {}

/// Event triggered when an image needs to be analyzed for nutritional content.
class AnalyzeImage extends FoodCaptureEvent {
  final String? imagePath;
  final String context;
  AnalyzeImage(this.imagePath, this.context);
}

/// Base class for all food capture states.
abstract class FoodCaptureState {}

/// Initial state of the food capture process.
class FoodCaptureInitial extends FoodCaptureState {}

/// State indicating that image analysis is in progress.
class FoodCaptureLoading extends FoodCaptureState {}

/// State indicating successful image analysis with nutrition info.
class FoodCaptureSuccess extends FoodCaptureState {
  final NutritionInfo nutritionInfo;
  FoodCaptureSuccess(this.nutritionInfo);
}

/// State indicating a failure in the image analysis process.
class FoodCaptureFailure extends FoodCaptureState {
  final String error;
  FoodCaptureFailure(this.error);
}

/// BLoC for managing the food capture process.
///
/// This BLoC handles the analysis of food images and updating of daily goals
/// based on the captured food entries.
class FoodCaptureBloc extends Bloc<FoodCaptureEvent, FoodCaptureState> {
  final NutritionService _nutritionService;
  final IFoodEntryRepository _foodEntryRepository;
  final IDailyGoalsRepository _dailyGoalsRepository;
  final IUserProfileRepository _userProfileRepository;

  FoodCaptureBloc(
    this._nutritionService,
    this._foodEntryRepository,
    this._dailyGoalsRepository,
    this._userProfileRepository,
  ) : super(FoodCaptureInitial()) {
    on<AnalyzeImage>(_onAnalyzeImage);
  }

  /// Handles the AnalyzeImage event by calling the nutrition service.
  Future<void> _onAnalyzeImage(
      AnalyzeImage event, Emitter<FoodCaptureState> emit) async {
    emit(FoodCaptureLoading());
    try {
      final nutritionInfo =
          await _nutritionService.analyzeImage(event.imagePath, event.context);
      emit(FoodCaptureSuccess(nutritionInfo));
    } catch (e) {
      emit(FoodCaptureFailure(e.toString()));
    }
  }

  /// Adds a new food entry and updates the daily goals accordingly.
  Future<void> addFoodEntryAndUpdateGoals(FoodEntry entry) async {
    await _foodEntryRepository.addFoodEntry(entry);
    await _updateDailyGoals(entry);
  }

  /// Updates the daily goals based on a new food entry.
  ///
  /// This method retrieves the current daily goals, updates them with the
  /// nutritional information from the new food entry, and saves the updated goals.
  Future<void> _updateDailyGoals(FoodEntry entry) async {
    final userProfile = await _userProfileRepository.getUserProfile();
    if (userProfile == null) return;

    final dateOnly =
        DateTime(entry.date.year, entry.date.month, entry.date.day);
    var dailyGoals = await _dailyGoalsRepository.getDailyGoals(dateOnly);

    dailyGoals ??= DailyGoals(
      userId: userProfile.id,
      date: dateOnly,
      goals: Map.from(userProfile.nutritionGoals),
    );

    // Define a mapping between nutrition info keys and daily goals keys
    final nutritionToGoalMapping = {
      'Calories': 'Calories',
      'Total Fat': 'Fats',
      'Total Carbohydrates': 'Carbs',
      'Dietary Fiber': 'Fiber',
      'Protein': 'Proteins',
    };

    // Update actual values based on the new food entry
    for (var component in entry.nutritionInfo.nutrition) {
      final goalKey = nutritionToGoalMapping[component.component];
      if (goalKey != null && dailyGoals.goals.containsKey(goalKey)) {
        var goal = dailyGoals.goals[goalKey]!;
        dailyGoals.goals[goalKey] = goal.copyWith(
          actual: goal.actual + component.value,
        );
      }
    }

    await _dailyGoalsRepository.saveDailyGoals(dailyGoals);
  }
}
