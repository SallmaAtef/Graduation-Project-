import 'dart:convert'; // Add this import for json decoding

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://your-fastapi-backend-url';

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/token'),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      // Parse the response body as JSON
      Map<String, dynamic> responseBody = json.decode(response.body);

      // Check if 'access_token' exists in the parsed JSON
      if (responseBody.containsKey('access_token')) {
        return {'success': true, 'token': responseBody['access_token']};
      } else {
        return {'success': false, 'error': 'Token not found in response'};
      }
    } else {
      // Handle other status codes (e.g., 401 for unauthorized)
      return {'success': false, 'error': 'Invalid credentials'};
    }
  }

  // Add methods for other API calls (e.g., signup, logout, etc.)
}
