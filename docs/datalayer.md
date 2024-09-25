# Comprehensive Data Architecture for Bioscope

## Overview

This document outlines the comprehensive data architecture for the Bioscope app, covering the core, domain, and data layers. It describes the current implementation using SQLite and Supabase, while preserving flexibility for future enhancements.

## Layer Structure

### Core Layer

The core layer contains interfaces and utilities that can be used across the entire application.

**Structure:**
- `lib/core/interfaces/data_source.dart`: Defines the generic DataSource interface.

### Domain Layer

The domain layer contains the core business logic, entities, and repository interfaces of the application. It should be independent of any external frameworks or libraries.

**Structure:**
For each entity (e.g., FoodEntry, UserProfile), create the following files in the `lib/domain` directory:
1. `entities/{entity_name}.dart`: Defines the entity class.
2. `repositories/{entity_name}_repository.dart`: Defines the abstract repository interface.
3. `usecases/{entity_name}/{usecase_name}.dart`: Defines individual use cases for the entity.

### Data Layer

The data layer implements the repositories defined in the domain layer and handles data persistence and retrieval.

**Structure:**
For each entity, create the following files in the `lib/data` directory:
1. `models/{entity_name}_model.dart`: Defines the data model, which is a serializable version of the domain entity.
2. `datasources/{entity_name}_{storage_type}_ds.dart`: Implements specific data storage (e.g., sqlite, supabase).
3. `repositories/{entity_name}_repository_impl.dart`: Implements the repository interface from the domain layer.

## Data Source Disambiguation Diagram

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
|SQL-| |SP | |Supa|
|ite | |   | |base|
+----+ +---+ +----+

SP: SharedPreferences
```

### Explanation of the diagram:

1. **Presentation Layer**: Contains UI components and uses Riverpod for state management and dependency injection.
2. **Domain Layer**: Contains business logic, use cases, and defines abstract repositories and entities.
3. **Data Layer**: Implements the repository pattern and manages data sources and their coordination.
4. **Local Store**: 
   - Primary: SQLite (implemented) for storing structured data like food entries.
   - Secondary: SharedPreferences (not yet implemented) for storing simple key-value pairs like user preferences.
5. **Remote Store**: Supabase for cloud storage and real-time synchronization.

## Current Implementation

### DataSource Interface

```dart
abstract class DataSource<T> {
  Future<void> initialize();
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<void> create(T item);
  Future<void> update(T item);
  Future<void> delete(String id);
  Stream<List<T>> watchAll();
  Stream<T?> watchById(String id);
}
```

### Concrete Implementations

1. **SQLiteDataSource**: 
   - Used for local storage of structured data.
   - Implements CRUD operations using SQLite database.

2. **SupabaseDataSource**: 
   - Used for remote storage and real-time synchronization.
   - Implements CRUD operations and real-time subscriptions using Supabase SDK.

### Repository Pattern

```dart
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
```

The Repository coordinates between local (SQLite) and remote (Supabase) data sources, implementing caching and offline-first strategies.

## Naming Conventions

- Use PascalCase for entity and use case class names.
- Use snake_case for file names.
- Prefix repository interfaces with "I" (e.g., IFoodEntryRepository).
- Suffix data models with "Model" (e.g., FoodEntryModel).
- Use specific storage type names for data sources (e.g., FoodEntrySqliteDs, UserProfileSupabaseDs).
- Suffix repository implementations with "RepositoryImpl" (e.g., FoodEntryRepositoryImpl).

## Example Structure

For a FoodEntry entity:

```
lib/
├── core/
│   └── interfaces/
│       └── data_source.dart
├── domain/
│   ├── entities/
│   │   └── food_entry.dart
│   ├── repositories/
│   │   └── food_entry_repository.dart
│   └── usecases/
│       └── food_entry/
│           ├── get_food_entries.dart
│           └── add_food_entry.dart
└── data/
    ├── models/
    │   └── food_entry_model.dart
    ├── datasources/
    │   ├── food_entry_sqlite_ds.dart
    │   └── food_entry_supabase_ds.dart
    └── repositories/
        └── food_entry_repository_impl.dart
```

## Future Considerations

1. **Evaluate Hive**: Consider Hive as an alternative to SQLite for simpler data structures or faster read/write operations.
2. **Enhance Supabase Integration**: 
   - Improve offline-first functionality.
   - Implement more sophisticated conflict resolution strategies.
3. **Error Handling and Connectivity**:
   - Implement robust error handling in the Repository.
   - Use a connectivity package to detect network status and adjust behavior accordingly.
4. **Migration Strategy**:
   - Design a migration strategy for local databases to handle schema changes.
   - Implement version control for local data to ensure compatibility with server data.
5. **Caching Strategies**:
   - Implement intelligent caching mechanisms to optimize data retrieval and reduce network calls.
6. **Real-time Updates**:
   - Leverage Supabase's real-time capabilities to provide instant updates across devices.

