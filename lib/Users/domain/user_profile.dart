import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../../common/infrastructure/base_url.dart';

class UserProfile with ChangeNotifier {
  String name;
  String email;
  String phoneNumber;
  String image = '';

  UserProfile({
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.image = '',
  });

  static UserProfile defaultProfile() {
    return UserProfile(
      name: "Carlos Alonzo", 
      email: "carlos.alonzo@example.com", 
      phoneNumber: "+58 4261234567",
      image: ""
    );
  }

  void updateProfile(String newName, String newPhoneNumber) {
    name = newName;
    phoneNumber = newPhoneNumber;
    notifyListeners(); 
  }

  Future<void> updateProfileFromToken(String token) async {
    final url = Uri.parse('$BaseUrl().BASE_URL/auth/current');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = convert.jsonDecode(response.body) as Map<String, dynamic>; // Cast to Map

        name = data['name'];
        email = data['email'];
        phoneNumber = data['phone'];
        image = data['image'] ?? ''; // Handle potential missing image key

        notifyListeners(); // Notify listeners of the state change
      } else {
        print('Error fetching user profile: ${response.statusCode}');
        // Handle potential errors (e.g., display a snackbar to the user)
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      // Handle exceptions (e.g., display a generic error message)
    }
  }
}
