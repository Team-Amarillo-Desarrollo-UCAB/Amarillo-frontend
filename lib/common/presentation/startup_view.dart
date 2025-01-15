import 'package:flutter/material.dart';
import '../../login/infrastructure/login_service.dart'; 
import '../../login/presentation/welcome_view.dart'; 
import '../infrastructure/session_manager.dart';
import 'main_tabview.dart'; 
import '../../common/infrastructure/base_url.dart';

class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  final SessionManager _sessionManager = SessionManager();
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
        if (BaseUrl().BASE_URL == BaseUrl().AMARILLO){
          _goToMainTabView();
          return;
        }
      }
      else if (BaseUrl().BASE_URL == BaseUrl().ORANGE || BaseUrl().BASE_URL == BaseUrl().VERDE) {
        _goToMainTabView();
        return;
      }
    }
    print("Sesión no válida. Redirigiendo a WelcomePage...");
    await _sessionManager.clearSession();
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
