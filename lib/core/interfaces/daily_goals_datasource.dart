import 'package:bioscope/core/interfaces/data_source.dart';
import 'package:bioscope/data/models/daily_goals_model.dart';

abstract class DailyGoalsDataSource extends DataSource<DailyGoalsModel> {
  Future<List<DailyGoalsModel>> getAll();
  Stream<List<DailyGoalsModel>> watchAll();
  Future<void> recalculate(DateTime date);
  Future<DailyGoalsModel?> getByDate(DateTime date);
}
