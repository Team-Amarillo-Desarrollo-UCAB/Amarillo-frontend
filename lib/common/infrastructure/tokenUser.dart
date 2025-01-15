import 'package:shared_preferences/shared_preferences.dart';

class TokenUser {
  static final TokenUser _instance = TokenUser._internal();

  factory TokenUser() {
    return _instance;
  }

  TokenUser._internal();

  String? _token;

  // Obtiene el token desde memoria o persistencia
  Future<String?> getToken() async {
    if (_token != null) return _token;

    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('authToken');
    return _token;
  }

  // Guarda el token de forma persistente
  Future<void> setToken(String? token) async {
    _token = token;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token as String);
  }

  // Elimina el token de persistencia
  Future<void> clearToken() async {
    _token = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }
}
