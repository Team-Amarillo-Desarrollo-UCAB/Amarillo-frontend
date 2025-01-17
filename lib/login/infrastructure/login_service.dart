import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Users/domain/user_profile.dart';
import '../../api/firebase_api.dart';
import '../../common/infrastructure/session_manager.dart'; 
import '../../common/infrastructure/base_url.dart';
import '../../common/infrastructure/tokenUser.dart';

class AuthService {
  final String baseUrl = BaseUrl().BASE_URL;
  final SessionManager _sessionManager = SessionManager();
  late final UserProfile userProfile;
  String url = '';

  AuthService() {
    _initializeUserProfile();
  }

  Future<void> _initializeUserProfile() async {
    userProfile = await UserProfile.loadFromPreferences();
  }
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final token = '';
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "email": email,
          "password": password,
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        final data = json.decode(response.body);

        if (data.containsKey("token")) {
          final token = data["token"];
          print("Token recibido del servidor: $token");
          await TokenUser().setToken(token);
          await _sessionManager.saveToken(token);
          final id = data["user"]["id"];
          getInfoUser(token, id);
          await FirebaseApi().initNotifications(token);
        }
        return Future.value(data);
      } else {
        return {"error": "Datos inválidos: revise los datos y vuelva a intentarlo"};
      }
    } catch (e) {
      return Future.value({"error": "Connection error: $e"});
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
        final data = json.decode(response.body);
        final name = data['name'] ?? '';
        final userEmail = data['email'] ?? '';
        final phoneNumber = data['phone'] ?? '';
        final userImage = data["image"] ?? 'https://cdn-icons-png.flaticon.com/512/10337/10337609.png';
        userProfile.userProfile(name, phoneNumber, userEmail, userImage);
        userProfile.reloadFromPreferences();
        if (response.statusCode == 200) {
          return true;
        }
        return response.statusCode == 200;
      } catch (e) {
        return false;
      }
  }
Future<bool> getInfoUser(String token, String id) async {
    if (BaseUrl().BASE_URL == BaseUrl().AMARILLO || BaseUrl().BASE_URL == BaseUrl().VERDE) {
      final url = Uri.parse('$baseUrl/auth/current');
      try {
        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
        final data = json.decode(response.body);
        final name = data['name'] ?? '';
        final userEmail = data['email'] ?? '';
        final phoneNumber = data['phone'] ?? '';
        final userImage = data["image"] ?? 'https://cdn-icons-png.flaticon.com/512/10337/10337609.png';
        userProfile.userProfile(name, phoneNumber, userEmail, userImage);
        userProfile.reloadFromPreferences();
        if (response.statusCode == 200) {
          return true;
        }
        return response.statusCode == 200;
      } catch (e) {
        return false;
      }
    } else if (BaseUrl().BASE_URL == BaseUrl().ORANGE) {
      final url = Uri.parse('$baseUrl/user/one/$id');
      try {
        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
        final data = json.decode(response.body);
        final name = data['name'] ?? '';
        final userEmail = data['email'] ?? '';
        final phoneNumber = data['phone'] ?? '';
        final userImage = data["image"] ?? 'https://cdn-icons-png.flaticon.com/512/10337/10337609.png';
        userProfile.userProfile(name, phoneNumber, userEmail, userImage);
        userProfile.reloadFromPreferences();
        if (response.statusCode == 200) {
          return true;
        }
        return response.statusCode == 200;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  Future<String> searchImage(String token) async {
    final url = Uri.parse('$baseUrl/auth/current');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final data = json.decode(response.body);
      final userImage = data["image"] ?? 'https://cdn-icons-png.flaticon.com/512/10337/10337609.png';

      if (response.statusCode == 200) {
        
      return userImage;
    }
    } catch (e) {
      return 'https://cdn-icons-png.flaticon.com/512/10337/10337609.png';
    }
    return 'https://cdn-icons-png.flaticon.com/512/10337/10337609.png';
  }

  Future<String?> getToken() async {
    return await _sessionManager.getToken();
  }

}
