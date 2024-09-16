import '../../entities/food_entry.dart';
import '../../repositories/food_entry_repository.dart';

class GetFoodEntries {
  final IFoodEntryRepository repository;

  GetFoodEntries(this.repository);

  Future<List<FoodEntry>> call() async {
    return await repository.getAllFoodEntries();
  }
}
