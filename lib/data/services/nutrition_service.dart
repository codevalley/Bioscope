import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bioscope/config/api_config.dart';
import 'package:bioscope/domain/entities/nutrition_info.dart';

class NutritionService {
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
      request.fields['service'] = 'mock';

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('API Response: ${response.body}'); // Debug log
        final jsonResponse = json.decode(response.body);
        try {
          return NutritionInfo.fromJson(jsonResponse);
        } catch (e) {
          print('Error parsing NutritionInfo: $e'); // Debug log
          rethrow;
        }
      } else {
        print('API Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to analyze food: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception in analyzeImage: $e');
      throw Exception('Failed to analyze food: $e');
    }
  }
}
