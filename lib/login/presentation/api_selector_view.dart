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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              DropdownButton<String>(
                value: _selectedBaseUrl,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(
                      value: 'Selecciona una API',
                      child: Text('Selecciona una API')),
                  DropdownMenuItem(value: 'AMARILLO', child: Text('AMARILLO')),
                  DropdownMenuItem(value: 'ORANGE', child: Text('ORANGE')),
                  DropdownMenuItem(value: 'VERDE', child: Text('VERDE')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    _updateBaseUrl(value);
                  }
                },
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 18,
                ),
                dropdownColor: TColor.placeholder,
                iconEnabledColor: TColor.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
