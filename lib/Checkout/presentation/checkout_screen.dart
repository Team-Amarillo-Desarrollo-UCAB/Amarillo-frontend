import 'package:desarrollo_frontend/Checkout/domain/direccion.dart';
import 'package:desarrollo_frontend/Checkout/infrastructure/payment_service.dart';
import 'package:desarrollo_frontend/Checkout/presentation/direcciones_screen.dart';
import 'package:desarrollo_frontend/Checkout/presentation/fecha_hora_widget.dart';
import 'package:desarrollo_frontend/Checkout/presentation/metodo_de_pago_widget.dart';
import 'package:desarrollo_frontend/Checkout/presentation/pie_pagina_widget.dart';
import 'package:flutter/material.dart';
import '../../common/infrastructure/base_url.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchPaymentMethods();
  }

  final PaymentService paymentService = PaymentService(BaseUrl().BASE_URL);

  final Map<String, TextEditingController> controllers = {};
  String selectedPaymentMethod = '';
  List<PaymentMethod> paymentFields = [];
  
  
  Future<void> _fetchPaymentMethods() async {
    try {
      List<PaymentMethod> paymentMethod = await paymentService.getPaymentMethods(1);
      setState(() {
        paymentFields = paymentMethod;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al obtener los métodos de pago: $error")),
      );
    }
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
              paymentMethods: paymentFields,
              onSelectedMethod: (method) {
                setState(() {
                  selectedPaymentMethod = method;
                  _generatePaymentFields(method);
                });
              },
            ),
            const Divider(),
            if (selectedPaymentMethod.isNotEmpty)
              ..._buildPaymentFields(),
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
                        if (!_validateFields()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Por favor, complete todos los campos.")),
                            );
                          }
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
  void _generatePaymentFields(String method) {
    setState(() {
      controllers.clear(); 
      if (method == 'c9710a23-6748-4841-aaf3-007a0a4caf74') {
        controllers['email'] = TextEditingController();
      } else if (method == 'f8386cbb-c503-450c-9829-6548b2c60b7c') {
        controllers['token'] = TextEditingController();
      }
    });
  }

  List<Widget> _buildPaymentFields() {
    List<Widget> fields = [];

    if (selectedPaymentMethod == 'c9710a23-6748-4841-aaf3-007a0a4caf74') {
      fields.add(
        TextField(
          controller: controllers['email'],
           keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Paypal Email',
            border: OutlineInputBorder(),
          ),
        ),
      );
    } else if (selectedPaymentMethod == 'f8386cbb-c503-450c-9829-6548b2c60b7c') {
      fields.add(
        TextField(
          controller: controllers['token'],
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Token de la tarjeta',
                    border: OutlineInputBorder(),
                  ),
                ),
      );
    }
    return fields;
  }
  bool _validateFields() {
  if (selectedPaymentMethod == 'c9710a23-6748-4841-aaf3-007a0a4caf74') {
    if (controllers['email'] == null || controllers['email']!.text.isEmpty) {
      return false;
    }
  } else if (selectedPaymentMethod == 'f8386cbb-c503-450c-9829-6548b2c60b7c') {
    if (controllers['token'] == null || controllers['token']!.text.isEmpty) {
      return false;
    }
  }
  return true; 
}
}
