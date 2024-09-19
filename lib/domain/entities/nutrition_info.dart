class NutritionInfo {
  final List<NutritionComponent> nutrition;
  final String summary;

  NutritionInfo({
    required this.nutrition,
    required this.summary,
  });

  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      nutrition: (json['nutrition'] as List)
          .map((item) => NutritionComponent.fromJson(item))
          .toList(),
      summary: json['summary'] as String,
    );
  }

  double get calories => _getComponentValue('Calories');
  double get protein => _getComponentValue('Protein');
  double get carbs => _getComponentValue('Total Carbohydrates');
  double get fat => _getComponentValue('Total Fat');

  double _getComponentValue(String componentName) {
    return nutrition
        .firstWhere((component) => component.component == componentName,
            orElse: () => NutritionComponent(
                component: componentName, confidence: 0, unit: '', value: 0))
        .value;
  }

  Map<String, dynamic> toJson() {
    return {
      'nutrition': nutrition.map((component) => component.toJson()).toList(),
      'summary': summary,
    };
  }
}

class NutritionComponent {
  final String component;
  final double confidence;
  final String unit;
  final double value;

  NutritionComponent({
    required this.component,
    required this.confidence,
    required this.unit,
    required this.value,
  });

  factory NutritionComponent.fromJson(Map<String, dynamic> json) {
    return NutritionComponent(
      component: json['component'] as String,
      confidence: _parseDouble(json['confidence']),
      unit: json['unit'] as String,
      value: _parseDouble(json['value']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else if (value is String) {
      return double.parse(value);
    }
    throw FormatException('Unable to parse $value to double');
  }

  Map<String, dynamic> toJson() {
    return {
      'component': component,
      'confidence': confidence,
      'unit': unit,
      'value': value,
    };
  }
}
