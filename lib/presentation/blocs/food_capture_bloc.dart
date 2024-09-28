import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bioscope/data/services/nutrition_service.dart';
import 'package:bioscope/domain/entities/nutrition_info.dart';
import 'package:bioscope/domain/repositories/food_entry_repository.dart';
import 'package:bioscope/domain/repositories/daily_goals_repository.dart';
import 'package:bioscope/domain/repositories/user_profile_repository.dart';
import 'package:bioscope/domain/entities/food_entry.dart';
import 'package:bioscope/domain/entities/daily_goals.dart';

// Events
abstract class FoodCaptureEvent {}

class AnalyzeImage extends FoodCaptureEvent {
  final String? imagePath;
  final String context;
  AnalyzeImage(this.imagePath, this.context);
}

// States
abstract class FoodCaptureState {}

class FoodCaptureInitial extends FoodCaptureState {}

class FoodCaptureLoading extends FoodCaptureState {}

class FoodCaptureSuccess extends FoodCaptureState {
  final NutritionInfo nutritionInfo;
  FoodCaptureSuccess(this.nutritionInfo);
}

class FoodCaptureFailure extends FoodCaptureState {
  final String error;
  FoodCaptureFailure(this.error);
}

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

  Future<void> addFoodEntryAndUpdateGoals(FoodEntry entry) async {
    await _foodEntryRepository.addFoodEntry(entry);
    await _updateDailyGoals(entry);
  }

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
