import 'package:desarrollo_frontend/Checkout/domain/direccion.dart';
import 'package:desarrollo_frontend/Checkout/presentation/direcciones_screen.dart';
import 'package:desarrollo_frontend/Checkout/presentation/fecha_hora_widget.dart';
import 'package:desarrollo_frontend/Checkout/presentation/metodo_de_pago_widget.dart';
import 'package:desarrollo_frontend/Checkout/presentation/pie_pagina_widget.dart';
import 'package:flutter/material.dart';
import '../../common/presentation/common_widget/round_button.dart';
import '../../Carrito/domain/cart_item.dart';
import '../../Carrito/infrastructure/cart_service.dart';
import '../../common/presentation/main_tabview.dart';
import '../../order/application/order_repository.dart';

class CheckoutScreen extends StatefulWidget {
  final int totalItems;
  final double totalPrice;
  final List<CartItem> listCartItems;
  final CartService cartService;
  const CheckoutScreen(
      {super.key,
      required this.totalItems,
      required this.totalPrice,
      required this.listCartItems,
      required this.cartService});

  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  OrderRepository orderRepository = OrderRepository();
  final List<Direccion> direcciones = [
    Direccion(
      nombre: 'Home "Fiscal"',
      direccionCompleta: 'Venezuela, Caracas...',
    ),
    Direccion(nombre: 'Oficina', direccionCompleta: 'Venezuela, Caracas...'),
  ];
  void _clearCart() {
    setState(() {
      widget.listCartItems.clear();
      widget.cartService.clearCartItems();
    });
  }

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Envía a',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            ListaDirecciones(
              direcciones: direcciones,
              onAddDireccion: () {
              },
            ),
            const SizedBox(height: 10),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Ingrese la fecha y hora de preferencial',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const FechaHoraSelector(),
            const SizedBox(height: 10),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Seleccione el metodo de pago',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            MetodosDePago(
              onSelectedMethod: (method) {
                setState(() {
                  selectedPaymentMethod = method;
                  controllers.clear();
                  for (var field in paymentFields[method]!) {
                    controllers[field['label']!] = TextEditingController();
                  }
                });
              },
            ),
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
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 110,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ResumenPedido(
                totalItems: widget.totalItems, totalPrice: widget.totalPrice),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundButton(
                    title: "Confirmar Pedido",
                    onPressed: () async {
                      try {
                        if (_validatePayment()) {
                        await widget.cartService
                            .createOrder(widget.listCartItems);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('¡Orden creada con éxito!'),
                            content: Text(
                                'Tu pedido ha sido procesado. ID de la orden: ${widget.cartService.idOrder}. Pronto recibirás una confirmación.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // orderRepository.addOrder(Order(
                                  //   orderId: widget.cartService.idOrder,
                                  //   items: widget.cartService.orderItems,
                                  // ));
                                  _clearCart();
                                Navigator.of(context)
                                    .pop(); 
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainTabView()//OrderHistoryScreen(orderRepository: orderRepository,
                                    ),
                                  
                                );
                                },
                                child: const Text('Continuar'),
                              ),
                            ],
                          ),
                        );
                        }else {
                          ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error al registrar el pago")),
                  );
                        }
                      } catch (error) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error al crear la orden'),
                            content: const Text(
                                'Ha ocurrido un error al procesar tu pedido. Por favor, inténtalo de nuevo más tarde.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop();
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
              ],
            ),
          ],
        ),
      ),
    );
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
  bool _validatePayment() {
    if (selectedPaymentMethod.isEmpty) return false;
    for (var controller in controllers.values) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }
}
