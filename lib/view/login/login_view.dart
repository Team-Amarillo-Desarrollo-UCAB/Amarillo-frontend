import 'package:flutter/material.dart';
import 'package:godely_front/common/color_extension.dart';
import 'package:godely_front/common_widget/round_button.dart';
import 'package:godely_front/common_widget/round_textfield.dart';
import '../main_tabview/main_tabview.dart';
import 'reset_password_view.dart';
import 'sing_up_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
  var media = MediaQuery.of(context).size;

    return Scaffold(
      
    body: Stack( // Use a Stack widget to position the image behind the content
    children: [
      // Add the background image as the first child
      Image.asset(
        "assets/img/fondologin.png",
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover, 
      ),

      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            children: [
              const SizedBox(
                height: 120,
              ),
              Image.asset(
                  "assets/img/app-logo.png",
                  width: media.width*0.70,
                ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Iniciar Sesión",
                style: TextStyle(
                    color: TColor.primary,
                    fontSize: 30,
                    fontWeight: FontWeight.w800),
              ),
              Text(
                "Ingresa tus datos",
                style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Correo Electrónico",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                            ],
                ),
              RoundTextfield(
                hintText: "Tu correo",
                controller: txtEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Contraseña",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                            ],
                ),
              RoundTextfield(
                hintText: "Contraseña",
                controller: txtPassword,
                obscureText: true,
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResetPasswordView(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(
                        color: TColor.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              RoundButton(
                  title: "Iniciar Sesión",
                  onPressed: () {
                    Navigator.push(context,  MaterialPageRoute(
            builder: (context) => const MainTabView(),),);
                    //btnLogin();
                  }),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpView(),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "¿No tienes una cuenta? ",
                      style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Regístrate",
                      style: TextStyle(
                          color: TColor.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
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
/*
  //TODO: Action
  void btnLogin() {
    if (!txtEmail.text.isEmail) {
      mdShowAlert(Globs.appName, MSG.enterEmail, () {});
      return;
    }

    if (txtPassword.text.length < 6) {
      mdShowAlert(Globs.appName, MSG.enterPassword, () {});
      return;
    }

    endEditing();

    serviceCallLogin({"email": txtEmail.text, "password": txtPassword.text, "push_token": "" });
  }

  //TODO: ServiceCall

  void serviceCallLogin(Map<String, dynamic> parameter) {
    Globs.showHUD();

    ServiceCall.post(parameter, SVKey.svLogin,
        withSuccess: (responseObj) async {
      Globs.hideHUD();
      if (responseObj[KKey.status] == "1") {
        
        Globs.udSet( responseObj[KKey.payload] as Map? ?? {} , Globs.userPayload);
        Globs.udBoolSet(true, Globs.userLogin);

          Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
            builder: (context) => const OnBoardingView(),
          ), (route) => false);
      } else {
        mdShowAlert(Globs.appName,
            responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (err) async {
      Globs.hideHUD();
      mdShowAlert(Globs.appName, err.toString(), () {});
    });
  }
}
*/
}