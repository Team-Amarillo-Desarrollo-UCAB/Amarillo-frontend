import 'package:desarrollo_frontend/domain/Checkout/direccion.dart';
import 'package:desarrollo_frontend/domain/Checkout/direcciones_screen.dart';
import 'package:desarrollo_frontend/domain/Checkout/fecha_hora_widget.dart';
import 'package:desarrollo_frontend/domain/Checkout/metodo_de_pago_widget.dart';
import 'package:desarrollo_frontend/domain/Checkout/payment_method_screen.dart';
import 'package:desarrollo_frontend/domain/Checkout/pie_pagina_widget.dart';
import 'package:flutter/material.dart';
import '../../common_widget/round_button.dart';
import '../Carrito/cart_item.dart';
import '../Carrito/cart_service.dart';
import '../order/order_repository.dart';

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
                // Lógica para añadir una nueva dirección de envío
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
            MetodosDePago(onSelectedMethod: (method) {
              // Lógica para seleccionar el método de pago
            }),
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
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterPaymentPage(
                                              totalItems: widget.totalItems,
                                              totalPrice: widget.totalPrice,
                                            ) //OrderHistoryScreen(orderRepository: orderRepository,
                                        ),
                                  );
                                },
                                child: const Text('Continuar'),
                              ),
                            ],
                          ),
                        );
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
                                      .pop(); // Cerrar el diálogo
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
}
