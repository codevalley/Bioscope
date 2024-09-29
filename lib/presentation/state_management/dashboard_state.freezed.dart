// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DashboardState {
  bool get isLoading => throw _privateConstructorUsedError;
  String get greeting => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  Map<String, GoalItem> get nutritionGoals =>
      throw _privateConstructorUsedError;
  Map<String, GoalItem> get dailyGoals => throw _privateConstructorUsedError;
  List<FoodEntry> get foodEntries => throw _privateConstructorUsedError;
  DateTime get currentDate => throw _privateConstructorUsedError;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardStateCopyWith<DashboardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStateCopyWith<$Res> {
  factory $DashboardStateCopyWith(
          DashboardState value, $Res Function(DashboardState) then) =
      _$DashboardStateCopyWithImpl<$Res, DashboardState>;
  @useResult
  $Res call(
      {bool isLoading,
      String greeting,
      String userName,
      Map<String, GoalItem> nutritionGoals,
      Map<String, GoalItem> dailyGoals,
      List<FoodEntry> foodEntries,
      DateTime currentDate});
}

/// @nodoc
class _$DashboardStateCopyWithImpl<$Res, $Val extends DashboardState>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? greeting = null,
    Object? userName = null,
    Object? nutritionGoals = null,
    Object? dailyGoals = null,
    Object? foodEntries = null,
    Object? currentDate = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      greeting: null == greeting
          ? _value.greeting
          : greeting // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionGoals: null == nutritionGoals
          ? _value.nutritionGoals
          : nutritionGoals // ignore: cast_nullable_to_non_nullable
              as Map<String, GoalItem>,
      dailyGoals: null == dailyGoals
          ? _value.dailyGoals
          : dailyGoals // ignore: cast_nullable_to_non_nullable
              as Map<String, GoalItem>,
      foodEntries: null == foodEntries
          ? _value.foodEntries
          : foodEntries // ignore: cast_nullable_to_non_nullable
              as List<FoodEntry>,
      currentDate: null == currentDate
          ? _value.currentDate
          : currentDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardStateImplCopyWith<$Res>
    implements $DashboardStateCopyWith<$Res> {
  factory _$$DashboardStateImplCopyWith(_$DashboardStateImpl value,
          $Res Function(_$DashboardStateImpl) then) =
      __$$DashboardStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      String greeting,
      String userName,
      Map<String, GoalItem> nutritionGoals,
      Map<String, GoalItem> dailyGoals,
      List<FoodEntry> foodEntries,
      DateTime currentDate});
}

/// @nodoc
class __$$DashboardStateImplCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res, _$DashboardStateImpl>
    implements _$$DashboardStateImplCopyWith<$Res> {
  __$$DashboardStateImplCopyWithImpl(
      _$DashboardStateImpl _value, $Res Function(_$DashboardStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? greeting = null,
    Object? userName = null,
    Object? nutritionGoals = null,
    Object? dailyGoals = null,
    Object? foodEntries = null,
    Object? currentDate = null,
  }) {
    return _then(_$DashboardStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      greeting: null == greeting
          ? _value.greeting
          : greeting // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      nutritionGoals: null == nutritionGoals
          ? _value._nutritionGoals
          : nutritionGoals // ignore: cast_nullable_to_non_nullable
              as Map<String, GoalItem>,
      dailyGoals: null == dailyGoals
          ? _value._dailyGoals
          : dailyGoals // ignore: cast_nullable_to_non_nullable
              as Map<String, GoalItem>,
      foodEntries: null == foodEntries
          ? _value._foodEntries
          : foodEntries // ignore: cast_nullable_to_non_nullable
              as List<FoodEntry>,
      currentDate: null == currentDate
          ? _value.currentDate
          : currentDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$DashboardStateImpl implements _DashboardState {
  const _$DashboardStateImpl(
      {required this.isLoading,
      required this.greeting,
      required this.userName,
      required final Map<String, GoalItem> nutritionGoals,
      required final Map<String, GoalItem> dailyGoals,
      required final List<FoodEntry> foodEntries,
      required this.currentDate})
      : _nutritionGoals = nutritionGoals,
        _dailyGoals = dailyGoals,
        _foodEntries = foodEntries;

  @override
  final bool isLoading;
  @override
  final String greeting;
  @override
  final String userName;
  final Map<String, GoalItem> _nutritionGoals;
  @override
  Map<String, GoalItem> get nutritionGoals {
    if (_nutritionGoals is EqualUnmodifiableMapView) return _nutritionGoals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionGoals);
  }

  final Map<String, GoalItem> _dailyGoals;
  @override
  Map<String, GoalItem> get dailyGoals {
    if (_dailyGoals is EqualUnmodifiableMapView) return _dailyGoals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dailyGoals);
  }

  final List<FoodEntry> _foodEntries;
  @override
  List<FoodEntry> get foodEntries {
    if (_foodEntries is EqualUnmodifiableListView) return _foodEntries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foodEntries);
  }

  @override
  final DateTime currentDate;

  @override
  String toString() {
    return 'DashboardState(isLoading: $isLoading, greeting: $greeting, userName: $userName, nutritionGoals: $nutritionGoals, dailyGoals: $dailyGoals, foodEntries: $foodEntries, currentDate: $currentDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.greeting, greeting) ||
                other.greeting == greeting) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            const DeepCollectionEquality()
                .equals(other._nutritionGoals, _nutritionGoals) &&
            const DeepCollectionEquality()
                .equals(other._dailyGoals, _dailyGoals) &&
            const DeepCollectionEquality()
                .equals(other._foodEntries, _foodEntries) &&
            (identical(other.currentDate, currentDate) ||
                other.currentDate == currentDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      greeting,
      userName,
      const DeepCollectionEquality().hash(_nutritionGoals),
      const DeepCollectionEquality().hash(_dailyGoals),
      const DeepCollectionEquality().hash(_foodEntries),
      currentDate);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStateImplCopyWith<_$DashboardStateImpl> get copyWith =>
      __$$DashboardStateImplCopyWithImpl<_$DashboardStateImpl>(
          this, _$identity);
}

abstract class _DashboardState implements DashboardState {
  const factory _DashboardState(
      {required final bool isLoading,
      required final String greeting,
      required final String userName,
      required final Map<String, GoalItem> nutritionGoals,
      required final Map<String, GoalItem> dailyGoals,
      required final List<FoodEntry> foodEntries,
      required final DateTime currentDate}) = _$DashboardStateImpl;

  @override
  bool get isLoading;
  @override
  String get greeting;
  @override
  String get userName;
  @override
  Map<String, GoalItem> get nutritionGoals;
  @override
  Map<String, GoalItem> get dailyGoals;
  @override
  List<FoodEntry> get foodEntries;
  @override
  DateTime get currentDate;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStateImplCopyWith<_$DashboardStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
