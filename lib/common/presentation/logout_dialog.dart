import 'package:desarrollo_frontend/common/presentation/color_extension.dart';
import 'package:desarrollo_frontend/login/presentation/welcome_view.dart';
import 'package:flutter/material.dart';
import '../infrastructure/session_manager.dart';

final SessionManager _sessionManager = SessionManager();
void showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)), // Bordes redondeados
        title: Column(
          children: [
            Icon(Icons.help_outline,
                size: 50, color: TColor.primary), // Ícono de pregunta
            const SizedBox(height: 10),
            const Text(
              "Cerrar Sesión",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ), // Título
          ],
        ),
        content: const Text(
          "¿Desea cerrar sesión de GoDely?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          // Botón "Cancelar"
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el popup
            },
            style: TextButton.styleFrom(
              foregroundColor: TColor.primaryText, // Color del texto
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ), // Estilo del botón
            child: const Text("Cancelar"),
          ), // TextButton
          // Botón "Sí, cerrar sesión"
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Cerrar el popup
              await _sessionManager.clearSession();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WelcomeView()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primary, // Color de fondo
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ), // Estilo del botón
            child: const Text("Sí, cerrar sesión",
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ), // ElevatedButton
        ], // Botones del AlertDialog
      ); // AlertDialog
    }, // Builder
  ); // showDialog
} // showLogoutConfirmationDialog
