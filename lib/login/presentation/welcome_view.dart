import 'package:flutter/material.dart';
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
              ],
            );
          },
        ),
      ),
    );
  }
}
