abstract class DataSource<T> {
  Future<void> initialize();
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<void> create(T item);
  Future<void> update(T item);
  Future<void> delete(String id);
  Stream<List<T>> watchAll();
  Stream<T?> watchById(String id);
  void setupRealtimeListeners(Function(List<T>) onDataChanged);
}
