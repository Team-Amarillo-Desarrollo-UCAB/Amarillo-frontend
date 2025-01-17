import 'package:desarrollo_frontend/Checkout/infrastructure/payment_service.dart';
import 'package:flutter/material.dart';

import '../../common/presentation/color_extension.dart';

class MetodosDePago extends StatefulWidget {
  final Function(PaymentMethod) onSelectedMethod;
  final List<PaymentMethod> paymentMethods;
  const MetodosDePago({
    super.key,
    required this.onSelectedMethod,
    required this.paymentMethods,
  });
  @override
  MetodosDePagoState createState() => MetodosDePagoState();
}

class MetodosDePagoState extends State<MetodosDePago> {
  String? _selectedMethod;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.paymentMethods.map((method) {
        return RadioListTile(
          title: Text(method.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
          value: method.idPayment,
          groupValue: _selectedMethod,
          onChanged: (value) {
            setState(() {
              _selectedMethod = value as String;
              widget.onSelectedMethod(method);
            });
          },
          activeColor: TColor.primary,
          controlAffinity: ListTileControlAffinity.leading,
        );
      }).toList(),
    );
  }
}
