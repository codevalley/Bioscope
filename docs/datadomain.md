# Data and Domain Layer Structure

This document outlines the structure and conventions for the core, domain, and data layers in our application. Following these guidelines ensures consistency across different entities and makes the codebase more maintainable.

## Core Layer

The core layer contains interfaces and utilities that can be used across the entire application.

### Structure

1. `lib/core/interfaces/data_source.dart`: Defines the generic DataSource interface.

## Domain Layer

The domain layer contains the core business logic, entities, and repository interfaces of the application. It should be independent of any external frameworks or libraries.

### Structure

For each entity (e.g., FoodEntry, User), create the following files in the `lib/domain` directory:

1. `entities/{entity_name}.dart`: Defines the entity class.
2. `repositories/{entity_name}_repository.dart`: Defines the abstract repository interface.
3. `usecases/{entity_name}/{usecase_name}.dart`: Defines individual use cases for the entity.

### Naming Conventions

- Use PascalCase for entity and use case class names.
- Use snake_case for file names.
- Prefix repository interfaces with "I" (e.g., IFoodEntryRepository).

## Data Layer

The data layer implements the repositories defined in the domain layer and handles data persistence and retrieval.

### Structure

For each entity, create the following files in the `lib/data` directory:

1. `models/{entity_name}_model.dart`: Defines the data model, which is a serializable version of the domain entity.
2. `datasources/{entity_name}_{storage_type}_ds.dart`: Implements specific data storage (e.g., sqlite, hive).
3. `datasources/{entity_name}_remote_ds.dart`: Implements remote data retrieval (e.g., API calls).
4. `repositories/{entity_name}_repository_impl.dart`: Implements the repository interface from the domain layer.

### Naming Conventions

- Use PascalCase for class names.
- Use snake_case for file names.
- Suffix data models with "Model" (e.g., FoodEntryModel).
- Use specific storage type names for local data sources (e.g., SqliteDs, HiveDs).
- Use "RemoteDs" suffix for remote data sources.
- Suffix repository implementations with "RepositoryImpl".

## Example

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
    │   └── food_entry_remote_ds.dart
    └── repositories/
        └── food_entry_repository_impl.dart
```

By following this structure and naming conventions, we ensure consistency across different entities and make it easier for developers to navigate and maintain the codebase.