import 'package:desarrollo_frontend/order/infrastructure/order_service_refund_stripe.dart';
import 'package:flutter/material.dart';

import '../../common/infrastructure/base_url.dart';

void showRefundDialog(BuildContext context, String orderId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirmar reembolso",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
        content: const Text("¿Desea pedir el reembolso para esta orden?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancelar",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
          ),
          TextButton(
            onPressed: () {
              _askRefund(context, orderId);
            },
            child: const Text("OK",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
          ),
        ],
      );
    },
  );
}

void _askRefund(BuildContext context, String orderId) async {
  final OrderAskRefund orderAskRefund = OrderAskRefund(BaseUrl().BASE_URL);
  final response = await orderAskRefund.askRefund(orderId);

  if (response.isSuccessful) {
    Future.delayed(const Duration(seconds: 3), () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Reembolso en proceso",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
            content: const Text(
                "En unos minutos te enviaremos una notificación para confirmar tu reembolso.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text("OK",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
              ),
            ],
          );
        },
      );
    });
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
          content: Text("Ocurrió un error: ${response.errorMessage}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
            ),
          ],
        );
      },
    );
  }
}
