import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bioscope/config/api_config.dart';
import 'package:bioscope/domain/entities/nutrition_info.dart';

class NutritionService {
  Future<NutritionInfo> analyzeImage(String imagePath, String context) async {
    try {
      var uri = Uri.parse('${ApiConfig.baseUrl}/analyze');
      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer ${ApiConfig.apiKey}';
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      request.fields['context'] = context;
      request.fields['service'] = 'claude';

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseBody);
        return NutritionInfo.fromJson(jsonResponse);
      } else {
        print('API Error: ${response.statusCode}');
        print('Response body: $responseBody');
        throw Exception('Failed to analyze image: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception in analyzeImage: $e');
      throw Exception('Failed to analyze image: $e');
    }
  }
}
