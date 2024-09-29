import '../../entities/food_entry.dart';
import '../../repositories/food_entry_repository.dart';

class GetEntriesByDate {
  final IFoodEntryRepository repository;

  GetEntriesByDate(this.repository);

  Future<List<FoodEntry>> call(DateTime date) async {
    return await repository.getEntriesByDate(date);
  }
}
