import 'package:desarrollo_frontend/login/presentation/login_view.dart';
import 'package:desarrollo_frontend/login/presentation/sing_up_view.dart';
import 'package:flutter/material.dart';
import '../../common/infrastructure/base_url.dart';
import '../../common/presentation/color_extension.dart';
import '../../common/presentation/common_widget/round_button.dart'; // Importa el RoundButton

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  void _showApiSelectionDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Seleccione la API a utilizar",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              RoundButton(
                title: "AMARILLO",
                onPressed: () {
                  _updateBaseUrl('AMARILLO');
                  Navigator.pop(context);
                },
                type: RoundButtonType.bgPrimary,
                customGradient: const LinearGradient(colors: [
                  Color(0xffFC6011),
                  Color.fromARGB(255, 252, 201, 17)
                ]), // Gradiente personalizado
              ),
              const SizedBox(height: 10),
              RoundButton(
                title: "ORANGE",
                onPressed: () {
                  _updateBaseUrl('ORANGE');
                  Navigator.pop(context);
                },
                type: RoundButtonType.bgPrimary,
                customGradient: const LinearGradient(colors: [
                  Color.fromARGB(255, 255, 142, 55),
                  Color.fromARGB(255, 255, 10, 10)
                ]), // Gradiente personalizado
              ),
              const SizedBox(height: 10),
              RoundButton(
                title: "VERDE",
                onPressed: () {
                  _updateBaseUrl('VERDE');
                  Navigator.pop(context);
                },
                type: RoundButtonType.bgPrimary,
                customGradient: const LinearGradient(colors: [
                  Color.fromARGB(255, 5, 150, 53),
                  Color.fromARGB(255, 59, 250, 123)
                ]), // Gradiente personalizado
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateBaseUrl(String selected) {
    setState(() {
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
                const SizedBox(height: 20),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RoundButton(
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.settings),
                          color: TColor.primary,
                          iconSize: 40,
                          onPressed: _showApiSelectionDialog,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
