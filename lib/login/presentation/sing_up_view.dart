import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../common/infrastructure/base_url.dart';
import '../../common/presentation/color_extension.dart';
import '../../common/presentation/common_widget/round_button.dart';
import '../../common/presentation/common_widget/round_textfield.dart';
import 'login_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  bool _isLoading = false;
  final String baseUrl = BaseUrl().BASE_URL;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  Future<void> _register() async {
    String name = txtName.text.trim();
    String mobile = txtMobile.text.trim();
    String email = txtEmail.text.trim();
    String password = txtPassword.text.trim();
    String confirmPassword = txtConfirmPassword.text.trim();

    if (name.isEmpty || mobile.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, completa todos los campos.")),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, ingresa un correo válido.")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Las contraseñas no coinciden.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var body;
      if (BaseUrl().BASE_URL == BaseUrl().AMARILLO || BaseUrl().BASE_URL == BaseUrl().ORANGE) {
        body = jsonEncode({
          "email": email,
          "name": name,
          "phone": mobile,
          //"image": "", 
          "type": "CLIENT",
          "password": password,
        });
      } else {
        body = jsonEncode({
          "email": email,
          "name": name,
          "password": password,
          "phone": mobile,
          "role": "CLIENT",
          
        });
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("¡Registro exitoso!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      } else {
        final error = jsonDecode(response.body)["error"] ?? "Error desconocido.";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ocurrió un error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Image.asset(
            "assets/img/fondologin.png",
            width: media.width,
            height: media.height,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: media.height * 0.03,
                horizontal: media.width * 0.07,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: media.height * 0.1),
                  Image.asset(
                    "assets/img/app-logo.png",
                    width: media.width * 0.7,
                  ),
                  SizedBox(height: media.height * 0.01),
                  Text(
                    "Regístrate",
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: media.width * 0.08,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: media.height * 0.009),
                  Text(
                    "Agrega tus detalles para registrarte",
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: media.width * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: media.height * 0.02),
                  RoundTextfield(
                    hintText: "Nombre",
                    controller: txtName,
                  ),
                  SizedBox(height: media.height * 0.02),
                  RoundTextfield(
                    hintText: "Email",
                    controller: txtEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: media.height * 0.02),
                  RoundTextfield(
                    hintText: "Número de teléfono",
                    controller: txtMobile,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: media.height * 0.02),
                  RoundTextfield(
                    hintText: "Contraseña",
                    controller: txtPassword,
                    obscureText: true,
                  ),
                  SizedBox(height: media.height * 0.02),
                  RoundTextfield(
                    hintText: "Confirma tu contraseña",
                    controller: txtConfirmPassword,
                    obscureText: true,
                  ),
                  SizedBox(height: media.height * 0.05),
                  _isLoading
                      ? CircularProgressIndicator()
                      : RoundButton(
                          title: "Regístrate",
                          onPressed: _register,
                        ),
                  SizedBox(height: media.height * 0.009),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "¿Ya tienes una cuenta? ",
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: media.width * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Inicia Sesión",
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: media.width * 0.035,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
