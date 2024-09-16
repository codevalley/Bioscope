import '../../domain/entities/food_entry.dart';

class FoodEntryModel extends FoodEntry {
  FoodEntryModel({
    required String id,
    required String name,
    required int calories,
    required DateTime date,
  }) : super(id: id, name: name, calories: calories, date: date);

  factory FoodEntryModel.empty() {
    return FoodEntryModel(
      id: '',
      name: '',
      calories: 0,
      date: DateTime.now(),
    );
  }

  factory FoodEntryModel.fromJson(Map<String, dynamic> json) {
    return FoodEntryModel(
      id: json['id'],
      name: json['name'],
      calories: json['calories'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'date': date.toIso8601String(),
    };
  }
}
