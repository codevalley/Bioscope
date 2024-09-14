// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$OnboardingState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(int currentPage, String? name,
            int? dailyCalorieGoal, List<String>? dietaryPreferences)
        inProgress,
    required TResult Function() complete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(int currentPage, String? name, int? dailyCalorieGoal,
            List<String>? dietaryPreferences)?
        inProgress,
    TResult? Function()? complete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(int currentPage, String? name, int? dailyCalorieGoal,
            List<String>? dietaryPreferences)?
        inProgress,
    TResult Function()? complete,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_InProgress value) inProgress,
    required TResult Function(_Complete value) complete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_InProgress value)? inProgress,
    TResult? Function(_Complete value)? complete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_InProgress value)? inProgress,
    TResult Function(_Complete value)? complete,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingStateCopyWith<$Res> {
  factory $OnboardingStateCopyWith(
          OnboardingState value, $Res Function(OnboardingState) then) =
      _$OnboardingStateCopyWithImpl<$Res, OnboardingState>;
}

/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res, $Val extends OnboardingState>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$OnboardingStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'OnboardingState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(int currentPage, String? name,
            int? dailyCalorieGoal, List<String>? dietaryPreferences)
        inProgress,
    required TResult Function() complete,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(int currentPage, String? name, int? dailyCalorieGoal,
            List<String>? dietaryPreferences)?
        inProgress,
    TResult? Function()? complete,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(int currentPage, String? name, int? dailyCalorieGoal,
            List<String>? dietaryPreferences)?
        inProgress,
    TResult Function()? complete,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_InProgress value) inProgress,
    required TResult Function(_Complete value) complete,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_InProgress value)? inProgress,
    TResult? Function(_Complete value)? complete,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_InProgress value)? inProgress,
    TResult Function(_Complete value)? complete,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements OnboardingState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$InProgressImplCopyWith<$Res> {
  factory _$$InProgressImplCopyWith(
          _$InProgressImpl value, $Res Function(_$InProgressImpl) then) =
      __$$InProgressImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {int currentPage,
      String? name,
      int? dailyCalorieGoal,
      List<String>? dietaryPreferences});
}

/// @nodoc
class __$$InProgressImplCopyWithImpl<$Res>
    extends _$OnboardingStateCopyWithImpl<$Res, _$InProgressImpl>
    implements _$$InProgressImplCopyWith<$Res> {
  __$$InProgressImplCopyWithImpl(
      _$InProgressImpl _value, $Res Function(_$InProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? name = freezed,
    Object? dailyCalorieGoal = freezed,
    Object? dietaryPreferences = freezed,
  }) {
    return _then(_$InProgressImpl(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      dailyCalorieGoal: freezed == dailyCalorieGoal
          ? _value.dailyCalorieGoal
          : dailyCalorieGoal // ignore: cast_nullable_to_non_nullable
              as int?,
      dietaryPreferences: freezed == dietaryPreferences
          ? _value._dietaryPreferences
          : dietaryPreferences // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc

class _$InProgressImpl implements _InProgress {
  const _$InProgressImpl(
      {required this.currentPage,
      this.name,
      this.dailyCalorieGoal,
      final List<String>? dietaryPreferences})
      : _dietaryPreferences = dietaryPreferences;

  @override
  final int currentPage;
  @override
  final String? name;
  @override
  final int? dailyCalorieGoal;
  final List<String>? _dietaryPreferences;
  @override
  List<String>? get dietaryPreferences {
    final value = _dietaryPreferences;
    if (value == null) return null;
    if (_dietaryPreferences is EqualUnmodifiableListView)
      return _dietaryPreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'OnboardingState.inProgress(currentPage: $currentPage, name: $name, dailyCalorieGoal: $dailyCalorieGoal, dietaryPreferences: $dietaryPreferences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InProgressImpl &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.dailyCalorieGoal, dailyCalorieGoal) ||
                other.dailyCalorieGoal == dailyCalorieGoal) &&
            const DeepCollectionEquality()
                .equals(other._dietaryPreferences, _dietaryPreferences));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentPage,
      name,
      dailyCalorieGoal,
      const DeepCollectionEquality().hash(_dietaryPreferences));

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InProgressImplCopyWith<_$InProgressImpl> get copyWith =>
      __$$InProgressImplCopyWithImpl<_$InProgressImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(int currentPage, String? name,
            int? dailyCalorieGoal, List<String>? dietaryPreferences)
        inProgress,
    required TResult Function() complete,
  }) {
    return inProgress(currentPage, name, dailyCalorieGoal, dietaryPreferences);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(int currentPage, String? name, int? dailyCalorieGoal,
            List<String>? dietaryPreferences)?
        inProgress,
    TResult? Function()? complete,
  }) {
    return inProgress?.call(
        currentPage, name, dailyCalorieGoal, dietaryPreferences);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(int currentPage, String? name, int? dailyCalorieGoal,
            List<String>? dietaryPreferences)?
        inProgress,
    TResult Function()? complete,
    required TResult orElse(),
  }) {
    if (inProgress != null) {
      return inProgress(
          currentPage, name, dailyCalorieGoal, dietaryPreferences);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_InProgress value) inProgress,
    required TResult Function(_Complete value) complete,
  }) {
    return inProgress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_InProgress value)? inProgress,
    TResult? Function(_Complete value)? complete,
  }) {
    return inProgress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_InProgress value)? inProgress,
    TResult Function(_Complete value)? complete,
    required TResult orElse(),
  }) {
    if (inProgress != null) {
      return inProgress(this);
    }
    return orElse();
  }
}

abstract class _InProgress implements OnboardingState {
  const factory _InProgress(
      {required final int currentPage,
      final String? name,
      final int? dailyCalorieGoal,
      final List<String>? dietaryPreferences}) = _$InProgressImpl;

  int get currentPage;
  String? get name;
  int? get dailyCalorieGoal;
  List<String>? get dietaryPreferences;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InProgressImplCopyWith<_$InProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CompleteImplCopyWith<$Res> {
  factory _$$CompleteImplCopyWith(
          _$CompleteImpl value, $Res Function(_$CompleteImpl) then) =
      __$$CompleteImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CompleteImplCopyWithImpl<$Res>
    extends _$OnboardingStateCopyWithImpl<$Res, _$CompleteImpl>
    implements _$$CompleteImplCopyWith<$Res> {
  __$$CompleteImplCopyWithImpl(
      _$CompleteImpl _value, $Res Function(_$CompleteImpl) _then)
      : super(_value, _then);

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CompleteImpl implements _Complete {
  const _$CompleteImpl();

  @override
  String toString() {
    return 'OnboardingState.complete()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CompleteImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(int currentPage, String? name,
            int? dailyCalorieGoal, List<String>? dietaryPreferences)
        inProgress,
    required TResult Function() complete,
  }) {
    return complete();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(int currentPage, String? name, int? dailyCalorieGoal,
            List<String>? dietaryPreferences)?
        inProgress,
    TResult? Function()? complete,
  }) {
    return complete?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(int currentPage, String? name, int? dailyCalorieGoal,
            List<String>? dietaryPreferences)?
        inProgress,
    TResult Function()? complete,
    required TResult orElse(),
  }) {
    if (complete != null) {
      return complete();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_InProgress value) inProgress,
    required TResult Function(_Complete value) complete,
  }) {
    return complete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_InProgress value)? inProgress,
    TResult? Function(_Complete value)? complete,
  }) {
    return complete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_InProgress value)? inProgress,
    TResult Function(_Complete value)? complete,
    required TResult orElse(),
  }) {
    if (complete != null) {
      return complete(this);
    }
    return orElse();
  }
}

abstract class _Complete implements OnboardingState {
  const factory _Complete() = _$CompleteImpl;
}
