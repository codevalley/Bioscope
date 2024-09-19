import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bioscope/data/services/nutrition_service.dart';
import 'package:bioscope/domain/entities/nutrition_info.dart';

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

  FoodCaptureBloc(this._nutritionService) : super(FoodCaptureInitial()) {
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
}
