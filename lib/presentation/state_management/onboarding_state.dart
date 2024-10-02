import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState.initial() = _Initial;
  const factory OnboardingState.inProgress({
    required int currentPage,
    String? name,
    required EmailVerificationStatus emailVerificationStatus,
    Map<String, double>? goals,
  }) = _InProgress;
  const factory OnboardingState.complete() = _Complete;
  const factory OnboardingState.error(String message) = _Error;
}

enum EmailVerificationStatus { notStarted, inProgress, verified, failed }
