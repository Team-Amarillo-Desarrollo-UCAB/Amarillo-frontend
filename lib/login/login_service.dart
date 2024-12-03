import 'dart:convert';
import 'package:http/http.dart' as http;
import '../common/session_manager.dart'; // Asegúrate de importar SessionManager
import '../common/base_url.dart';

class AuthService {
  final String baseUrl = BaseUrl().BASE_URL;
  final SessionManager _sessionManager = SessionManager();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data.containsKey("token")) {
          final token = data["token"];
          print("Token recibido del servidor: $token");
          await _sessionManager.saveToken(token);
        }
        return data;
      } else {
        return {"error": "Datos inválidos: revise los datos y vuelva a intentarlo"};
      }
    } catch (e) {
      return {"error": "Connection error: $e"};
    }
  }

  Future<bool> isValidToken(String token) async {
    final url = Uri.parse('$baseUrl/auth/current');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getToken() async {
    return await _sessionManager.getToken();
  }

}
