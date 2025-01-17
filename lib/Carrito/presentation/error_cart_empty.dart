import 'package:flutter/material.dart';

import '../../common/presentation/color_extension.dart';

void showCartEmptyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)), // Bordes redondeados
        title: Column(
          children: const [
            Icon(Icons.error,
                size: 50, color: Colors.orangeAccent), // Ícono de pregunta
            SizedBox(height: 10),
            Text(
              "Carrito vacío",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ), // Título
          ],
        ),
        content: const Text(
          "No puede proceder a la checkout sin tener al menos un item en carrito",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              gradient: TColor.gradient,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Cerrar el popup
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                shadowColor: Colors.transparent,
              ),
              child: const Text(
                'Entendido',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      );
    },
  );
}
