import 'package:uuid/uuid.dart';

class FoodEntry {
  final String id;
  final String? name;
  final int? calories;
  final DateTime? date;

  FoodEntry({
    String? id,
    this.name,
    this.calories,
    this.date,
  }) : id = id ?? const Uuid().v4();

  factory FoodEntry.fromMap(Map<String, dynamic> map) {
    return FoodEntry(
      id: map['id'],
      name: map['name'],
      calories: map['calories'],
      date: DateTime.parse(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'date': date?.toIso8601String() ?? '',
    };
  }
}
