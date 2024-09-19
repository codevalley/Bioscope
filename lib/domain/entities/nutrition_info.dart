class NutritionInfo {
  final String summary;
  final List<NutritionComponent> nutrition;

  NutritionInfo({required this.summary, required this.nutrition});

  // Add a getter for calories
  int get calories {
    final caloriesComponent = nutrition.firstWhere(
      (component) => component.component.toLowerCase() == 'calories',
      orElse: () => NutritionComponent(
          component: 'Calories', value: 0, unit: 'kcal', confidence: 1.0),
    );
    return caloriesComponent.value.round();
  }

  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      summary: json['summary'] as String,
      nutrition: (json['nutrition'] as List<dynamic>)
          .map((e) => NutritionComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'nutrition': nutrition.map((e) => e.toJson()).toList(),
    };
  }

  factory NutritionInfo.empty() {
    return NutritionInfo(
      summary: '',
      nutrition: [],
    );
  }
}

class NutritionComponent {
  final String component;
  final double value;
  final String unit;
  final double confidence;

  NutritionComponent({
    required this.component,
    required this.value,
    required this.unit,
    required this.confidence,
  });

  factory NutritionComponent.fromJson(Map<String, dynamic> json) {
    return NutritionComponent(
      component: json['component'] as String,
      value: (json['value'] as num).toDouble(), // Convert num to double
      unit: json['unit'] as String,
      confidence:
          (json['confidence'] as num).toDouble(), // Convert num to double
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'component': component,
      'value': value,
      'unit': unit,
      'confidence': confidence,
    };
  }
}
