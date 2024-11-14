import 'package:flutter/material.dart';

class MetodosDePago extends StatefulWidget {
  const MetodosDePago({super.key});
  @override
  MetodosDePagoState createState() => MetodosDePagoState();
}

class MetodosDePagoState extends State<MetodosDePago> {
  String? _selectedMethod;

  final List<String> _paymentMethods = [
    'Efectivo',
    'Tarjeta de crédito',
    'Tarjeta de débito',
    'Paypal',
    'Pago Móvil',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _paymentMethods.map((method) {
        return RadioListTile(
          title: Text(
            method,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          value: method,
          groupValue: _selectedMethod,
          onChanged: (value) {
            setState(() {
              _selectedMethod = value;
            });
          },
          activeColor: Colors.orange,
          controlAffinity: ListTileControlAffinity.leading,
        );
      }).toList(),
    );
  }
}
