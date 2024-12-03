import 'package:desarrollo_frontend/on_boarding/startup_view.dart';
import 'package:flutter/material.dart';
import '../common/session_manager.dart';

final SessionManager _sessionManager = SessionManager();
// Función para mostrar el popup de confirmación
void showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Bordes redondeados
        title: Column(
          children: const [
            Icon(Icons.help_outline, size: 50, color: Colors.orangeAccent), // Ícono de pregunta
            SizedBox(height: 10),
            Text(
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
        ), // Texto del mensaje
        actions: [
          // Botón "Cancelar"
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el popup
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey, // Color del texto
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ), // Estilo del botón
            child: const Text("Cancelar"),
          ), // TextButton
          // Botón "Sí, cerrar sesión"
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Cerrar el popup
              await _sessionManager.clearSession();
              Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>StartupView())); // Navegar al login
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ), // Estilo del botón
            child: const Text("Sí, cerrar sesión"),
          ), // ElevatedButton
        ], // Botones del AlertDialog
      ); // AlertDialog
    }, // Builder
  ); // showDialog
} // showLogoutConfirmationDialog
