import 'package:desarrollo_frontend/Checkout/domain/direccion.dart';
import 'package:desarrollo_frontend/Checkout/infrastructure/payment_service.dart';
import 'package:desarrollo_frontend/Checkout/presentation/Agregar_Direccion.dart';
import 'package:desarrollo_frontend/Checkout/presentation/direcciones_screen.dart';
import 'package:desarrollo_frontend/Checkout/presentation/fecha_hora_widget.dart';
import 'package:desarrollo_frontend/Checkout/presentation/metodo_de_pago_widget.dart';
import 'package:desarrollo_frontend/Checkout/presentation/pie_pagina_widget.dart';
import 'package:desarrollo_frontend/Combo/domain/combo.dart';
import 'package:desarrollo_frontend/Cupon/domain/Cupon.dart';
import 'package:desarrollo_frontend/Cupon/presentation/cupon_screen.dart';
import 'package:desarrollo_frontend/Producto/domain/product.dart';
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
  final List<Direccion> _direcciones = [];
  DateTime? _selectedDateTime;
  List<Product> listProducts = [];
  List<Combo> listCombos = [];
  Cupon? selectedCupon;

  @override
  void initState() {
    super.initState();
    _fetchPaymentMethods();
    _divideCartItems();
  }

  void _divideCartItems() {
    for (var cartItem in widget.listCartItems) {
      if (cartItem.isCombo) {
        listCombos.add(Combo(
          id_product: cartItem.id_product,
          images: [cartItem.imageUrl],
          name: cartItem.name,
          price: cartItem.price.toString(),
          productId: cartItem.productId!,
          peso: cartItem.peso,
          description: cartItem.description,
          discount: cartItem.discount,
          category: cartItem.category,
        ));
      } else {
        listProducts.add(Product(
          id_product: cartItem.id_product,
          name: cartItem.name,
          price: cartItem.price.toString(),
          description: cartItem.description,
          peso: cartItem.peso,
          images: [cartItem.imageUrl],
          category: cartItem.category,
          discount: cartItem.discount,
        ));
      }
    }
  }

  void _clearCart() {
    setState(() {
      widget.listCartItems.clear();
      listProducts.clear();
      listCombos.clear();
      widget.cartService.clearCartItems();
    });
  }

  final PaymentService paymentService = PaymentService(BaseUrl().BASE_URL);

  final Map<String, TextEditingController> controllers = {};
  String selectedPaymentMethod = '';
  List<PaymentMethod> paymentFields = [];

  Future<void> _fetchPaymentMethods() async {
    try {
      List<PaymentMethod> paymentMethod =
          await paymentService.getPaymentMethods(1);
      setState(() {
        paymentFields = paymentMethod;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al obtener los métodos de pago: $error")),
      );
    }
  }

  void _addDireccion(Direccion direccion) {
    setState(() {
      _direcciones.add(direccion);
    });
  }

  void _removeDireccion(Direccion direccion) {
    setState(() {
      _direcciones.remove(direccion);
    });
  }

  Future<void> _selectCupon() async {
    final Cupon? cupon = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CuponView()),
    );
    if (cupon != null && mounted) {
      setState(() {
        selectedCupon = cupon;
      });
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
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
              direcciones: _direcciones,
              onAddDireccion: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddDireccionDialog(onAdd: _addDireccion);
                  },
                );
              },
              onRemoveDireccion: _removeDireccion,
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
            FechaHoraSelector(
              onDateTimeSelected: (selectedDateTime) {
                setState(() {
                  _selectedDateTime = selectedDateTime;
                });
              },
            ),
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
            if (selectedPaymentMethod.isNotEmpty) ..._buildPaymentFields(),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cupones',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  selectedCupon == null
                      ? const Text(
                          'No hay cupón seleccionado',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        )
                      : Text(
                          'Cupón seleccionado: ${selectedCupon!.code} - ${selectedCupon!.amount}%',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _selectCupon,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[400],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Seleccionar cupón',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
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
                            SnackBar(
                                content: Text(
                                    "Por favor, complete todos los campos.")),
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
                                  _clearCart();
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainTabView()),
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
                                  Navigator.of(context).pop();
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
    } else if (selectedPaymentMethod ==
        'f8386cbb-c503-450c-9829-6548b2c60b7c') {
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
    } else if (selectedPaymentMethod ==
        'f8386cbb-c503-450c-9829-6548b2c60b7c') {
      if (controllers['token'] == null || controllers['token']!.text.isEmpty) {
        return false;
      }
    }
    return true;
  }
}
