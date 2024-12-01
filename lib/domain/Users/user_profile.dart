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
      name: "Carlos Alonzo", // Nombre por defecto
      email: "carlos.alonzo@example.com", // Email por defecto
      phoneNumber: "+58 4261234567", // Número por defecto
    );
  }

  void updateProfile(String newName, String newPhoneNumber) {
    name = newName;
    phoneNumber = newPhoneNumber;
    notifyListeners(); // Notifica a las vistas que el estado ha cambiado
  }
}
