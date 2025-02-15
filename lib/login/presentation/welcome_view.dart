import 'package:flutter/material.dart';

import '../../common/infrastructure/base_url.dart';
import '../../common/presentation/color_extension.dart';
import '../../common/presentation/common_widget/round_button.dart';
import 'login_view.dart';
import 'sing_up_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {

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
}

  @override
  Widget build(BuildContext context) {
    //var media = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.asset(
                      "assets/img/top-splash.png",
                      width: constraints.maxWidth, 
                    ),
                    Image.asset(
                      "assets/img/GoDely-vertical.png",
                      width: constraints.maxWidth * 0.55, 
                      height: constraints.maxWidth * 0.55,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                const SizedBox(height: 1.0), 
                Text(
                  "Encuentra los mejores productos\ny vive la experiencia del más \nrápido delivery del país",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: constraints.maxWidth > 600 ? 20.0 : 18.0, 
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20.0), 
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.1), 
                  child: RoundButton(
                    title: "Iniciar Sesión",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20.0), 
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.1), 
                  child: RoundButton(
                    title: "Crear una cuenta",
                    type: RoundButtonType.textPrimary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpView(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20.0), 
                          const SizedBox(height: 20),
              DropdownButton<String>(
                value: _selectedBaseUrl,
                items: const [
                  DropdownMenuItem(value: 'Selecciona una API', child: Text('Selecciona una API')),
                  DropdownMenuItem(value: 'AMARILLO', child: Text('AMARILLO')),
                  DropdownMenuItem(value: 'ORANGE', child: Text('ORANGE')),
                  DropdownMenuItem(value: 'VERDE', child: Text('VERDE')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    _updateBaseUrl(value);
                  }
                },
              ),
              ],
            );
          },
        ),
      ),
    );
  }
}