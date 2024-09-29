import 'package:bioscope/core/interfaces/data_source.dart';
import 'package:bioscope/data/models/food_entry_model.dart';

abstract class FoodEntryDataSource extends DataSource<FoodEntryModel> {
  Future<List<FoodEntryModel>> getAll();
  Stream<List<FoodEntryModel>> watchAll();
  Future<List<FoodEntryModel>> getByDate(DateTime date);
}
