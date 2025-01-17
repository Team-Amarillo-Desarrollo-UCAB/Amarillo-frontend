import 'package:flutter/material.dart';
import '../../common/presentation/color_extension.dart';
import 'metodo_de_pago_widget.dart';

class RegisterPaymentPage extends StatefulWidget {
  final int totalItems;
  final double totalPrice;

  const RegisterPaymentPage({
    Key? key,
    required this.totalItems,
    required this.totalPrice,
  }) : super(key: key);
  @override
  _RegisterPaymentPageState createState() => _RegisterPaymentPageState();
}

class _RegisterPaymentPageState extends State<RegisterPaymentPage> {
  double discount = 0.0;

  String selectedPaymentMethod = '';
  final Map<String, TextEditingController> controllers = {};

  final Map<String, List<Map<String, String>>> paymentFields = {
    'Pago Móvil': [
      {'label': 'Teléfono de origen', 'type': 'phone'},
      {'label': 'Monto', 'type': 'number'},
      {'label': 'Nro. de Referencia', 'type': 'text'},
    ],
    'Paypal': [
      {'label': 'Correo electrónico', 'type': 'email'},
      {'label': 'Monto', 'type': 'number'},
    ],
    'Tarjeta de crédito': [
      {'label': 'Número de tarjeta', 'type': 'number'},
      {'label': 'Fecha de expiración (MM/AA)', 'type': 'text'},
      {'label': 'CVV', 'type': 'number'},
    ],
    'Tarjeta de débito': [
      {'label': 'Número de tarjeta', 'type': 'number'},
      {'label': 'Fecha de expiración (MM/AA)', 'type': 'text'},
      {'label': 'CVV', 'type': 'number'},
    ],
    'Efectivo': [],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Registrar Pago"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    color: TColor.primary,
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Detalles del pago",
                      style: TextStyle(
                        color: TColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total de productos: ${widget.totalItems}"),
                            Text(
                              "Total: \$${widget.totalPrice.toStringAsFixed(2)}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey.shade300),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Descuento"),
                            Text(
                              discount == 0.0
                                  ? "-"
                                  : "\$${discount.toStringAsFixed(2)}",
                              style: TextStyle(
                                color:
                                    discount > 0 ? Colors.green : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "\$${(widget.totalPrice - discount).toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            // Métodos de pago
            const Text(
              "Método de Pago",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            // MetodosDePago(
            //   onSelectedMethod: (method) {
            //     setState(() {
            //       selectedPaymentMethod = method;
            //       controllers.clear();
            //       for (var field in paymentFields[method]!) {
            //         controllers[field['label']!] = TextEditingController();
            //       }
            //     });
            //   },
            // ),
            const Divider(),
            if (selectedPaymentMethod.isNotEmpty)
              ...paymentFields[selectedPaymentMethod]!.map(
                (field) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: controllers[field['label']],
                    keyboardType: _getKeyboardType(field['type']!),
                    decoration: InputDecoration(
                      labelText: field['label'],
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_validatePayment()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Pago registrado exitosamente")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error al registrar el pago")),
                  );
                }
              },
              child: const Text("Registrar pago",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validatePayment() {
    if (selectedPaymentMethod.isEmpty) return false;
    for (var controller in controllers.values) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  TextInputType _getKeyboardType(String type) {
    switch (type) {
      case 'number':
        return TextInputType.number;
      case 'phone':
        return TextInputType.phone;
      case 'email':
        return TextInputType.emailAddress;
      default:
        return TextInputType.text;
    }
  }
}
