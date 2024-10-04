/// Represents nutritional information for a food item.
class NutritionInfo {
  /// A summary of the nutritional information.
  final String summary;

  /// A list of individual nutritional components.
  final List<NutritionComponent> nutrition;

  /// Creates a new [NutritionInfo] instance.
  NutritionInfo({required this.summary, required this.nutrition});

  /// Calculates the total calories from the nutrition components.
  int get calories {
    final caloriesComponent = nutrition.firstWhere(
      (component) => component.component.toLowerCase() == 'calories',
      orElse: () => NutritionComponent(
          component: 'Calories', value: 0, unit: 'kcal', confidence: 1.0),
    );
    return caloriesComponent.value.round();
  }

  /// Creates a [NutritionInfo] instance from a JSON map.
  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      summary: json['summary'] as String,
      nutrition: (json['nutrition'] as List<dynamic>)
          .map((e) => NutritionComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Converts this [NutritionInfo] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'nutrition': nutrition.map((e) => e.toJson()).toList(),
    };
  }

  /// Creates an empty [NutritionInfo] instance.
  factory NutritionInfo.empty() {
    return NutritionInfo(
      summary: '',
      nutrition: [],
    );
  }
}

/// Represents a single nutritional component (e.g., protein, carbohydrates).
class NutritionComponent {
  /// The name of the nutritional component.
  final String component;

  /// The amount of this component.
  final double value;

  /// The unit of measurement for this component.
  final String unit;

  /// The confidence level of this nutritional information (0.0 to 1.0).
  final double confidence;

  /// Creates a new [NutritionComponent] instance.
  NutritionComponent({
    required this.component,
    required this.value,
    required this.unit,
    required this.confidence,
  });

  /// Creates a [NutritionComponent] instance from a JSON map.
  factory NutritionComponent.fromJson(Map<String, dynamic> json) {
    return NutritionComponent(
      component: json['component'] as String,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  /// Converts this [NutritionComponent] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'component': component,
      'value': value,
      'unit': unit,
      'confidence': confidence,
    };
  }
}
