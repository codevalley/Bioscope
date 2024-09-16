import 'package:uuid/uuid.dart';

class FoodEntry {
  final String id;
  final String name;
  final int calories;
  final DateTime date;

  FoodEntry({
    String? id,
    required this.name,
    required this.calories,
    required this.date,
  }) : id = id ?? const Uuid().v4();
}
