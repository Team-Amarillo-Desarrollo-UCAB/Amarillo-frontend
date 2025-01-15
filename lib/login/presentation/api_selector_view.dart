import 'package:desarrollo_frontend/login/presentation/welcome_view.dart';
import 'package:flutter/material.dart';
import '../../common/infrastructure/base_url.dart';
import '../../common/presentation/color_extension.dart';
import '../../common/presentation/common_widget/round_button.dart'; // Importa el RoundButton

class ApiSelectionView extends StatefulWidget {
  @override
  _ApiSelectionViewState createState() => _ApiSelectionViewState();
}

class _ApiSelectionViewState extends State<ApiSelectionView> {
  String _selectedBaseUrl = 'Selecciona una API';

  void _updateBaseUrl(String selected) {
    setState(() {
      _selectedBaseUrl = selected;
      switch (selected) {
        case 'AMARILLO':
          BaseUrl().BASE_URL = BaseUrl().AMARILLO;
          break;
        case 'ORANGE':
          BaseUrl().BASE_URL = BaseUrl().ORANGE;
          break;
        case 'VERDE':
          BaseUrl().BASE_URL = BaseUrl().VERDE;
          break;
      }
    });
    print("Base URL seleccionada: ${BaseUrl().BASE_URL}");

    // Navegar a la pantalla principal
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/img/fondologin.png",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/img/GoDely-vertical.png",
                    width: MediaQuery.of(context).size.width * 0.55,
                    height: MediaQuery.of(context).size.width * 0.55,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Seleccione la API a utilizar",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        RoundButton(
                          title: "AMARILLO",
                          onPressed: () => _updateBaseUrl('AMARILLO'),
                          type: RoundButtonType.bgPrimary,
                          customColor: const LinearGradient(colors: [
                            Color(0xffFC6011),
                            Color.fromARGB(255, 252, 201, 17)
                          ]), // Color personalizado
                        ),
                        const SizedBox(height: 10),
                        RoundButton(
                          title: "ORANGE",
                          onPressed: () => _updateBaseUrl('ORANGE'),
                          type: RoundButtonType.bgPrimary,
                          customColor: const LinearGradient(colors: [
                            Color.fromARGB(255, 255, 142, 55),
                            Color.fromARGB(255, 255, 10, 10)
                          ]), // Color personalizado
                        ),
                        const SizedBox(height: 10),
                        RoundButton(
                          title: "VERDE",
                          onPressed: () => _updateBaseUrl('VERDE'),
                          type: RoundButtonType.bgPrimary,
                          customColor: const LinearGradient(colors: [
                            Color.fromARGB(255, 5, 150, 53),
                            Color.fromARGB(255, 59, 250, 123)
                          ]), // Color personalizado
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
