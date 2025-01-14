import 'package:flutter/material.dart';

void showRefundDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirmar reembolso"),
        content: const Text("¿Desea pedir el reembolso para esta orden?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              _askRefund(context); 
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

void _askRefund(BuildContext context) {
  
  Future.delayed(const Duration(seconds: 3), () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Reembolso en proceso"),
          content: const Text(
              "En unos minutos te enviaremos una notificación para confirmar tu reembolso."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  });
}
