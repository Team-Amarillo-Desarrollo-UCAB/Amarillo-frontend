import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class NotFoundScreen extends StatelessWidget {
  final String texto;
  NotFoundScreen({Key? key, required this.texto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              "https://assets10.lottiefiles.com/packages/lf20_02epxjye.json",
              width: screenWidth / 3 * 2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth / 7),
              child: Text(
                "No se ha encontrado: $texto",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.indigo,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}