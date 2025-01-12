import 'package:flutter/material.dart';
import '../infrastructure/paypal_service.dart';

class PayPalPaymentPage extends StatefulWidget {
  @override
  _PayPalPaymentPageState createState() => _PayPalPaymentPageState();
}

class _PayPalPaymentPageState extends State<PayPalPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simulación de Pago con PayPal'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            startPayPalPayment(context);
          },
          child: Text('Pagar con PayPal'),
        ),
      ),
    );
  }

  void startPayPalPayment(BuildContext context) {
    PayPalService payPalService = PayPalService();
    payPalService.simulatePayment(context: context);
  }
}