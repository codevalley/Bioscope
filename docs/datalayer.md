# Data Layer Design for Bioscope

**Data Layer Design**

```dart
// Data Layer Design for Bioscope

// 1. Abstract Data Source
abstract class DataSource<T> {
  Future<void> initialize();
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<void> create(T item);
  Future<void> update(T item);
  Future<void> delete(String id);
}

// 2. Concrete Implementations
class SQLiteDataSource<T> implements DataSource<T> {
  // SQLite implementation
}

class HiveDataSource<T> implements DataSource<T> {
  // Hive implementation
}

class ReactiveDataSource<T> implements DataSource<T> {
  // Reactive local-first store implementation (e.g., Supabase)
}

class RestApiDataSource<T> implements DataSource<T> {
  // REST API implementation
}

// 3. Repository
class Repository<T> {
  final DataSource<T> localDataSource;
  final DataSource<T> remoteDataSource;

  Repository({required this.localDataSource, required this.remoteDataSource});

  Future<List<T>> getAll() async {
    try {
      final remoteData = await remoteDataSource.getAll();
      await localDataSource.initialize();
      for (var item in remoteData) {
        await localDataSource.create(item);
      }
      return remoteData;
    } catch (e) {
      return localDataSource.getAll();
    }
  }

  // Implement other CRUD operations with similar pattern
}

// 4. Usage Example
class FoodEntryRepository extends Repository<FoodEntry> {
  FoodEntryRepository({
    required DataSource<FoodEntry> localDataSource,
    required DataSource<FoodEntry> remoteDataSource,
  }) : super(localDataSource: localDataSource, remoteDataSource: remoteDataSource);

  // Add any FoodEntry specific methods here
}

```

Now, let's discuss the approach and choices for implementing this data layer:

1. Abstraction Layer:
   - We'll use an abstract `DataSource` class to define the common interface for all data sources.
   - This abstraction allows us to easily switch between different data sources without affecting the rest of the application.

2. Local Data Storage:
   - For local storage, we can implement both SQLite and Hive options:
     - SQLite: Good for complex queries and relational data.
     - Hive: Excellent for simple key-value storage and fast performance.
   - We'll create concrete implementations for both (`SQLiteDataSource` and `HiveDataSource`).
   - The choice between SQLite and Hive can be made based on specific requirements for each data type.

3. Reactive Local-First Store:
   - Supabase is a good choice for a reactive local-first store. It provides real-time capabilities and offline support.
   - We'll implement a `ReactiveDataSource` that uses Supabase SDK for Flutter.
   - This will allow for real-time updates and offline-first functionality.

4. REST API:
   - We'll implement a `RestApiDataSource` to handle communication with the server.
   - This will serve as the source of truth for the application.

5. Repository Pattern:
   - We'll use the Repository pattern to coordinate between local and remote data sources.
   - The Repository will handle the logic of fetching from the remote source, caching locally, and falling back to local data when offline.

6. Data Flow:
   - The app will primarily interact with the Repository.
   - The Repository will first try to fetch from the remote source (REST API).
   - If successful, it will update the local storage (SQLite/Hive) and return the data.
   - If the remote fetch fails, it will fall back to the local storage.

7. Reactive Updates:
   - For real-time updates, we can use Supabase's real-time capabilities.
   - The Repository can expose streams of data that components can listen to for reactive updates.

8. Dependency Injection:
   - We'll use dependency injection to provide the appropriate data sources to the Repository.
   - This allows for easy switching between data sources (e.g., SQLite vs. Hive) without changing the Repository code.

9. Error Handling and Connectivity:
   - Implement robust error handling in the Repository.
   - Use a connectivity package to detect network status and adjust behavior accordingly.

10. Migration Strategy:
    - Design a migration strategy for local databases to handle schema changes.
    - Implement version control for local data to ensure compatibility with server data.

This approach provides a flexible and robust data layer that can handle different types of data sources while maintaining a clean abstraction for the rest of the application. It allows for easy switching between data sources and provides a clear path for implementing offline-first functionality and real-time updates.

To implement this, you'll need to:
1. Update your pubspec.yaml to include necessary packages (sqflite, hive, supabase, http for REST API).
2. Implement the concrete data sources.
3. Update the existing `FoodEntryRepository` to use this new structure.
4. Adjust the UI and business logic layers to work with the new Repository structure.

## Current Implementation

### Data Source Disambiguation Diagram

```
+-------------------+
|   Presentation    |
|      Layer        |
+--------+----------+
         |
         | Riverpod (State Management)
         |
+--------v----------+
|     Domain        |
|      Layer        |
+--------+----------+
         |
         | Repository Pattern
         |
+--------v----------+
|      Data         |
|      Layer        |
+---+----+----+-----+
    |    |    |
    |    |    |
+---v-+  |  +-v---+  +------------+
|Local|  |  |Remote| |Future Options|
|Store|  |  |Store | +------------+
+--+--+  |  +--+---+ | - Supabase  |
   |     |     |     | (Edge Store)|
   |     |     |     +------------+
   |     |     |
+--v-+ +-v-+ +-v--+
|SQL-| |SP | |Mock|
|ite | |   | |API |
+----+ +---+ +----+

SP: SharedPreferences
```

### Explanation of the diagram:

1. **Presentation Layer**:
   - Contains UI components.
   - Uses Riverpod for state management and dependency injection.

2. **Domain Layer**:
   - Contains business logic and use cases.
   - Defines abstract repositories and entities.

3. **Data Layer**:
   - Implements the repository pattern.
   - Manages data sources and their coordination.

4. **Local Store**:
   - Primary: SQLite (implemented)
     - Used for storing structured data like food entries.
   - Secondary: SharedPreferences (not yet implemented)
     - Could be used for storing simple key-value pairs like user preferences.

5. **Remote Store**:
   - Currently using a mock implementation.
   - In the future, this will be replaced with a real REST API client.

6. **Future Options**:
   - Supabase: Could be used as an edge store for real-time synchronization and offline-first capabilities.

### Current Implementation Details:

- We're using SQLite for local storage of food entries.
- A mock remote data source is in place for simulating remote operations.
- Riverpod is used for state management and dependency injection.
- The Repository pattern is implemented to coordinate between local and remote data sources.

### Future Considerations:

1. Implement SharedPreferences for storing user preferences and app settings.
2. Replace the mock remote data source with a real REST API client.
3. Consider integrating Supabase as an edge store for real-time synchronization and offline-first functionality.
4. Evaluate Hive as a potential alternative to SQLite for local storage, especially if we need faster read/write operations for simpler data structures.

### Clarification on Hive and Supabase:

- **Hive**: This is an alternative to SQLite for local storage. It's not currently implemented but could be considered in the future as a replacement for SQLite if we need better performance for simpler data structures.

- **Supabase**: This is primarily an option for edge storage, providing real-time synchronization and offline-first capabilities. It's not a direct alternative to SQLite or Hive but rather a comprehensive solution that could potentially replace both our local and remote stores in the future.

In the current implementation, we're using SQLite for local storage and a mock API for remote storage. The consideration of Hive and Supabase is part of our future planning to potentially improve our data layer architecture.
