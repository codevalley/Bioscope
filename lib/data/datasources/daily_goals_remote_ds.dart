import '../../core/interfaces/daily_goals_datasource.dart';
import '../models/daily_goals_model.dart';
import '../../core/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Remote API implementation of the [DailyGoalsDataSource] interface.
///
/// This class provides methods to interact with a generic remote API
/// for storing and retrieving daily nutritional goals.
class DailyGoalsRemoteDs implements DailyGoalsDataSource {
  final String baseUrl;
  final http.Client httpClient;

  /// Creates a new instance of [DailyGoalsRemoteDs].
  ///
  /// Requires a [baseUrl] for the API and an [http.Client] for making HTTP requests.
  DailyGoalsRemoteDs(this.baseUrl, this.httpClient);

  /// Initializes the connection to the remote API.
  @override
  Future<void> initialize() async {
    // Implement any necessary initialization (e.g., authentication)
    // For now, we'll just log that initialization is complete
    Logger.log('DailyGoalsRemoteDs initialized');
  }

  /// Retrieves all daily goals from the remote API.
  ///
  /// Returns a [Future] that completes with a list of [DailyGoalsModel].
  @override
  Future<List<DailyGoalsModel>> getAll(
      {DateTime? startDate, DateTime? endDate}) async {
    final response = await httpClient.get(Uri.parse('$baseUrl/daily-goals'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => DailyGoalsModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load daily goals');
    }
  }

  /// Retrieves a specific daily goal by its ID from the remote API.
  ///
  /// [id] The unique identifier of the daily goal.
  /// Returns a [Future] that completes with the [DailyGoalsModel] if found, or null otherwise.
  @override
  Future<DailyGoalsModel?> getById(String id) async {
    final response =
        await httpClient.get(Uri.parse('$baseUrl/daily-goals/$id'));
    if (response.statusCode == 200) {
      return DailyGoalsModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load daily goal');
    }
  }

  /// Retrieves the daily goals for a specific date from the remote API.
  ///
  /// [date] The date for which to retrieve goals.
  /// Returns a [Future] that completes with a [DailyGoalsModel] if found, or null otherwise.
  @override
  Future<DailyGoalsModel?> getByDate(DateTime date) async {
    final dateString = date.toIso8601String().split('T')[0];
    final response = await httpClient
        .get(Uri.parse('$baseUrl/daily-goals/date/$dateString'));
    if (response.statusCode == 200) {
      return DailyGoalsModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load daily goal for date');
    }
  }

  /// Creates a new daily goal entry in the remote API.
  ///
  /// [item] The [DailyGoalsModel] to be created.
  @override
  Future<void> create(DailyGoalsModel item) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/daily-goals'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(item.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create daily goal');
    }
  }

  /// Updates an existing daily goal entry in the remote API.
  ///
  /// [item] The [DailyGoalsModel] to be updated.
  @override
  Future<void> update(DailyGoalsModel item) async {
    final response = await httpClient.put(
      Uri.parse('$baseUrl/daily-goals/${item.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(item.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update daily goal');
    }
  }

  /// Deletes a daily goal entry from the remote API.
  ///
  /// [id] The unique identifier of the daily goal to be deleted.
  @override
  Future<void> delete(String id) async {
    final response =
        await httpClient.delete(Uri.parse('$baseUrl/daily-goals/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete daily goal');
    }
  }

  /// Provides a stream of all daily goals.
  ///
  /// This method is not typically implemented for REST APIs and throws an [UnimplementedError].
  @override
  Stream<List<DailyGoalsModel>> watchAll() {
    // Implement if the API supports real-time updates or polling
    throw UnimplementedError('watchAll is not implemented for REST API');
  }

  /// Provides a stream of a specific daily goal by its ID.
  ///
  /// This method is not typically implemented for REST APIs and throws an [UnimplementedError].
  @override
  Stream<DailyGoalsModel?> watchById(String id) {
    // Implement if the API supports real-time updates or polling
    throw UnimplementedError('watchById is not implemented for REST API');
  }

  /// Sets up real-time listeners for data changes.
  ///
  /// This method is not typically implemented for REST APIs and does nothing.
  @override
  void setupRealtimeListeners(Function(List<DailyGoalsModel>) onDataChanged) {
    // Implement if the API supports WebSocket or Server-Sent Events
    Logger.log('setupRealtimeListeners is not implemented for REST API');
  }

  /// Recalculates the daily goals for a specific date.
  ///
  /// [date] The date for which to recalculate goals.
  @override
  Future<void> recalculate(DateTime date) async {
    final dateString = date.toIso8601String().split('T')[0];
    final response = await httpClient.post(
      Uri.parse('$baseUrl/daily-goals/recalculate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'date': dateString}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to recalculate daily goals');
    }
  }
}
