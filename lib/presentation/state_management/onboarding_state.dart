import 'package:freezed_annotation/freezed_annotation.dart';
part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState.initial() = _Initial;
  const factory OnboardingState.inProgress({
    required int currentPage,
    String? name,
    Map<String, double>? goals,
    List<String>? dietaryPreferences,
  }) = _InProgress;
  const factory OnboardingState.complete() = _Complete;
  const factory OnboardingState.error(String message) = _Error;
}
