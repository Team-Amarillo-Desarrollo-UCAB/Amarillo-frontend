import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile with ChangeNotifier {
  String name;
  String email;
  String phoneNumber;
  String image;

  UserProfile({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.image,
  });

  void updateProfile(String newName, String newPhoneNumber, String newEmail) {
    name = newName;
    phoneNumber = newPhoneNumber;
    email = newEmail;
    notifyListeners();
    _saveToPreferences();
  }

    void userProfile(String newName, String newPhoneNumber, String newEmail, String newImage) {
    name = newName;
    phoneNumber = newPhoneNumber;
    email = newEmail;
    image = newImage;
    notifyListeners();
    _saveToPreferences();
  }

    void loadUserImage(String newImage) {
    image = newImage;
    _saveToPreferences();
  }
  
  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_name', name);
    prefs.setString('user_phone_number', phoneNumber);
    prefs.setString('user_email', email);
    prefs.setString('user_image', image);
    notifyListeners();
    print("Datos guardados en _saveToPreferences: name=$name, phoneNumber=$phoneNumber, email=$email, image=$image");
  }

  
  static Future<UserProfile> loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? "Carlos Alonzo";
    final phoneNumber = prefs.getString('user_phone_number') ?? "+58 4261234567";
    final email = prefs.getString('user_email') ?? "carlos.alonzo@example.com";
    final image = prefs.getString('user_image') ?? 'https://res.cloudinary.com/dxttqmyxu/image/upload/v1733191533/lbkmeso0kbvxnj6wvetd.jpg';
    print("Datos cargados en loadFromPreferences: name=$name, phoneNumber=$phoneNumber, email=$email, image=$image");
    
    return UserProfile(
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      image: image
    );
  }

  Future<void> reloadFromPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  name = prefs.getString('user_name') ?? name;
  phoneNumber = prefs.getString('user_phone_number') ?? phoneNumber;
  email = prefs.getString('user_email') ?? email;
  image = prefs.getString('user_image') ?? image;
  print("Datos cargados en reloadFromPreferences: name=$name, phoneNumber=$phoneNumber, email=$email, image=$image");
  notifyListeners();
}

}
