import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bioscope/config/api_config.dart';
import 'package:bioscope/domain/entities/nutrition_info.dart';
import 'package:bioscope/core/utils/logger.dart';

/// Service class for handling nutrition-related API calls.
class NutritionService {
  /// Analyzes an image or text description to extract nutritional information.
  ///
  /// [imagePath] Optional path to an image file to be analyzed.
  /// [context] A text description of the food item.
  ///
  /// Returns a [Future] that completes with a [NutritionInfo] object containing
  /// the analyzed nutritional information.
  ///
  /// Throws an [Exception] if the API call fails or the response cannot be parsed.
  Future<NutritionInfo> analyzeImage(String? imagePath, String context) async {
    try {
      var uri = Uri.parse('${ApiConfig.baseUrl}/analyze');
      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer ${ApiConfig.apiKey}';
      if (imagePath != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imagePath));
      }
      request.fields['context'] = context;
      request.fields['service'] = 'claude';

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Logger.log('API Response: ${response.body}'); // Debug log
        final jsonResponse = json.decode(response.body);
        try {
          return NutritionInfo.fromJson(jsonResponse);
        } catch (e) {
          Logger.log('Error parsing NutritionInfo: $e'); // Debug log
          rethrow;
        }
      } else {
        Logger.log('API Error: ${response.statusCode}');
        Logger.log('Response body: ${response.body}');
        throw Exception('Failed to analyze food: ${response.reasonPhrase}');
      }
    } catch (e) {
      Logger.log('Exception in analyzeImage: $e');
      throw Exception('Failed to analyze food: $e');
    }
  }
}
