/// Defines a generic interface for data sources in the application.
///
/// This abstract class provides a common set of operations that all data sources
/// should implement, regardless of the specific type of data they handle.
///
/// The type parameter [T] represents the model type that this data source operates on.
abstract class DataSource<T> {
  /// Initializes the data source.
  ///
  /// This method should be called before any other operations are performed.
  /// It can be used to set up database connections, initialize caches, etc.
  Future<void> initialize();

  /// Retrieves an item by its unique identifier.
  ///
  /// [id] The unique identifier of the item to retrieve.
  /// Returns a [Future] that completes with the item if found, or null otherwise.
  Future<T?> getById(String id);

  /// Creates a new item in the data source.
  ///
  /// [item] The item to create.
  Future<void> create(T item);

  /// Updates an existing item in the data source.
  ///
  /// [item] The item to update. The implementation should use the item's ID to identify it.
  Future<void> update(T item);

  /// Deletes an item from the data source.
  ///
  /// [id] The unique identifier of the item to delete.
  Future<void> delete(String id);

  /// Provides a stream of updates for a specific item.
  ///
  /// [id] The unique identifier of the item to watch.
  /// Returns a [Stream] that emits the updated item whenever it changes, or null if it's deleted.
  Stream<T?> watchById(String id);

  /// Sets up real-time listeners for data changes.
  ///
  /// This method is used to establish real-time connections (e.g., WebSockets) to receive
  /// updates from the data source.
  ///
  /// [onDataChanged] A callback function that will be called with the updated list of items
  /// whenever the data changes.
  void setupRealtimeListeners(Function(List<T>) onDataChanged);
}
