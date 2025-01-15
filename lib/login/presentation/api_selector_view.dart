import 'package:desarrollo_frontend/login/presentation/welcome_view.dart';
import 'package:flutter/material.dart';
import '../../common/infrastructure/base_url.dart';
import '../../common/presentation/color_extension.dart';

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
      backgroundColor: Colors.white,
      body: Center(
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
              Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.circle, color: Colors.yellow),
                    title: Text('AMARILLO'),
                    onTap: () => _updateBaseUrl('AMARILLO'),
                  ),
                  ListTile(
                    leading: Icon(Icons.circle, color: Colors.orange),
                    title: Text('ORANGE'),
                    onTap: () => _updateBaseUrl('ORANGE'),
                  ),
                  ListTile(
                    leading: Icon(Icons.circle, color: Colors.green),
                    title: Text('VERDE'),
                    onTap: () => _updateBaseUrl('VERDE'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
