import 'package:flutter/material.dart';
import '../../login/infrastructure/login_service.dart'; // Servicio de autenticación
import '../../login/presentation/welcome_view.dart'; // Vista de bienvenida
import 'main_tabview.dart'; // Vista principal

class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    await Future.delayed(const Duration(seconds: 3));
    final token = await _authService.getToken();
    if (token != null) {
      print("Token encontrado: $token");
      final isValid = await _authService.isValidToken(token);
      print("¿Token válido? $isValid");
      if (isValid) {
        _goToMainTabView();
        return;
      }
    }
    print("Sesión no válida. Redirigiendo a WelcomePage...");
    _goToWelcomePage();
  }

  void _goToMainTabView() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainTabView()),
    );
  }

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
