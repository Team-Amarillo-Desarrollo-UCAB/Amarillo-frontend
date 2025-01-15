import 'package:desarrollo_frontend/order/infrastructure/order_service_refund_stripe.dart';
import 'package:flutter/material.dart';

import '../../common/infrastructure/base_url.dart';



void showRefundDialog(BuildContext context, String orderId) {
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
              _askRefund(context, orderId); 
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

void _askRefund(BuildContext context, String orderId) async{

  final OrderAskRefund orderAskRefund = OrderAskRefund(BaseUrl().BASE_URL);
  final response = await orderAskRefund.askRefund(orderId);
  
  if(response.isSuccessful){
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
  }else{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text("Ocurrió un error: ${response.errorMessage}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
