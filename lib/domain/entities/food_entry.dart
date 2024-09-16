import 'package:uuid/uuid.dart';

class FoodEntry {
  final String id;
  final String name;
  final int calories;
  final DateTime date;
  final String? imagePath;

  FoodEntry({
    String? id,
    required this.name,
    required this.calories,
    required this.date,
    this.imagePath,
  }) : id = id ?? const Uuid().v4();
}
