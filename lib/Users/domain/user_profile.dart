import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile with ChangeNotifier {
  String name;
  String email;
  String phoneNumber;

  UserProfile({
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  static UserProfile defaultProfile() {
    return UserProfile(
      name: "Carlos Alonzo", 
      email: "carlos.alonzo@example.com", 
      phoneNumber: "+58 4261234567",
    );
  }

  /// Actualiza los datos del perfil y guarda en SharedPreferences
  void updateProfile(String newName, String newPhoneNumber) {
    name = newName;
    phoneNumber = newPhoneNumber;
    notifyListeners();
    _saveToPreferences();
  }

  
  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_name', name);
    prefs.setString('user_phone_number', phoneNumber);
    prefs.setString('user_email', email);
  }

  
  static Future<UserProfile> loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? "Carlos Alonzo";
    final phoneNumber = prefs.getString('user_phone_number') ?? "+58 4261234567";
    final email = prefs.getString('user_email') ?? "carlos.alonzo@example.com";

    return UserProfile(
      name: name,
      email: email,
      phoneNumber: phoneNumber,
    );
  }
}
