import 'package:flutter/material.dart';
import '../login/login_service.dart'; // Servicio de autenticación
import '../login/welcome_view.dart'; // Vista de bienvenida
import '../main_tabview/main_tabview.dart'; // Vista principal

class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  final AuthService _authService = AuthService(); // Instancia del servicio de autenticación

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  /// Verifica si el usuario tiene una sesión activa
  void _checkSession() async {
    await Future.delayed(const Duration(seconds: 3)); // Simula tiempo de carga
    final token = await _authService.getToken(); // Obtiene el token almacenado
    if (token != null) {
      print("Token encontrado: $token");
      final isValid = await _authService.isValidToken(token); // Valida el token
      print("¿Token válido? $isValid");
      if (isValid) {
        _goToMainTabView(); // Navega al `MainTabView` si el token es válido
        return;
      }
    }
    print("Sesión no válida. Redirigiendo a WelcomePage...");
    _goToWelcomePage(); // Si no hay sesión activa, navega al `WelcomeView`
  }


  /// Navega a la vista principal
  void _goToMainTabView() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainTabView()),
    );
  }

  /// Navega a la vista de bienvenida
  void _goToWelcomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/img/Splash.png",
            width: media.width,
            height: media.height,
            fit: BoxFit.cover,
          ),
          Image.asset(
            "assets/img/GoDely-vertical.png",
            width: media.width * 0.40,
            height: media.height * 0.40,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
