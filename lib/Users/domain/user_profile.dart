import 'package:flutter/material.dart';

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

  void updateProfile(String newName, String newPhoneNumber) {
    name = newName;
    phoneNumber = newPhoneNumber;
    notifyListeners(); 
  }
}
