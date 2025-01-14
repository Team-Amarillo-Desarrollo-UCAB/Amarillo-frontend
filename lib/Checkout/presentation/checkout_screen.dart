import 'dart:convert';

import 'package:desarrollo_frontend/Checkout/domain/direccion.dart';
import 'package:desarrollo_frontend/Checkout/infrastructure/payment_service.dart';
import 'package:desarrollo_frontend/Checkout/presentation/Agregar_Direccion.dart';
import 'package:desarrollo_frontend/Checkout/presentation/direcciones_screen.dart';
import 'package:desarrollo_frontend/Checkout/presentation/fecha_hora_widget.dart';
import 'package:desarrollo_frontend/Checkout/presentation/metodo_de_pago_widget.dart';
import 'package:desarrollo_frontend/Checkout/presentation/paypal_payment_page.dart';
import 'package:desarrollo_frontend/Checkout/presentation/pie_pagina_widget.dart';
import 'package:desarrollo_frontend/Combo/domain/combo.dart';
import 'package:desarrollo_frontend/Cupon/domain/Cupon.dart';
import 'package:desarrollo_frontend/Cupon/presentation/cupon_screen.dart';
import 'package:desarrollo_frontend/Producto/domain/product.dart';
import 'package:desarrollo_frontend/common/presentation/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/infrastructure/base_url.dart';
import '../../common/presentation/common_widget/round_button.dart';
import '../../Carrito/domain/cart_item.dart';
import '../../Carrito/infrastructure/cart_service.dart';
import '../../common/presentation/main_tabview.dart';
import '../../order/application/order_repository.dart';
import 'stripe_payment_view1.dart';

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
  List<CartItem> listProducts = [];
  List<CartItem> listCombos = [];
  Cupon? selectedCupon;
  String? selectedToken;
  String selectedEmail = '';
  PaymentMethod? selectedPaymentMethod;
  Direccion? selectedDireccion;
  String instructions = 'Entregar por la puerta roja de la esquina';

  @override
  void initState() {
    super.initState();
    _fetchPaymentMethods();
    _divideCartItems();
    _loadDirecciones();
  }

  Future<void> _loadDirecciones() async {
    final prefs = await SharedPreferences.getInstance();
    final String? direccionesString = prefs.getString('direcciones');
    if (direccionesString != null) {
      final List<dynamic> direccionesJson = json.decode(direccionesString);
      setState(() {
        _direcciones.clear();
        _direcciones.addAll(direccionesJson
            .map((json) => Direccion(
                  nombre: json['nombre'],
                  direccionCompleta: json['direccionCompleta'],
                  latitude: json['latitude'],
                  longitude: json['longitude'],
                  isSelected: json['isSelected'],
                ))
            .toList());
      });
    }
  }

  Future<void> _saveDirecciones() async {
    final prefs = await SharedPreferences.getInstance();
    final String direccionesString = json.encode(_direcciones
        .map((direccion) => {
              'nombre': direccion.nombre,
              'direccionCompleta': direccion.direccionCompleta,
              'latitude': direccion.latitude,
              'longitude': direccion.longitude,
              'isSelected': direccion.isSelected
            })
        .toList());
    await prefs.setString('direcciones', direccionesString);
  }

  void _divideCartItems() {
    for (var cartItem in widget.listCartItems) {
      if (cartItem.isCombo) {
        listCombos.add(cartItem);
      } else {
        listProducts.add(cartItem);
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
      _saveDirecciones();
    });
  }

  void _removeDireccion(Direccion direccion) {
    setState(() {
      _direcciones.remove(direccion);
      _saveDirecciones();
    });
  }

  void _selectDireccion(Direccion direccion) {
    setState(() {
      selectedDireccion = direccion;
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

  Future<void> _tokenStripe() async {
    final String? token = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => StripePaymentView(amount: widget.totalPrice)),
    );
    if (token != null && mounted) {
      setState(() {
        selectedToken = token;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        backgroundColor: TColor.secondary,
        title: const Text(
          'Checkout',
          style: TextStyle(
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
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Envía a',
                style: TextStyle(
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
              onSelectDireccion: _selectDireccion,
            ),
            const SizedBox(height: 10),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Ingrese la fecha y hora de preferencial',
                style: TextStyle(
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
                });
                if (method.name == 'Stripe') {
                  _tokenStripe();
                } else {}
              },
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cupones',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  selectedCupon == null
                      ? const Text(
                          'No hay cupón seleccionado',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        )
                      : Text(
                          'Cupón seleccionado: ${selectedCupon!.code} - ${selectedCupon!.amount}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: _selectCupon,
                    icon: Icon(
                      Icons.card_giftcard,
                      color: TColor.primary,
                    ),
                    label: Text(
                      'Seleccionar cupón',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: TColor.primary),
                    ),
                  ),
                ],
              ),
            ),
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
                TextButton.icon(
                  onPressed: () async {
                    try {
                      if (!_validateFields()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Por favor, complete todos los campos."),
                          ),
                        );
                      }
                      await widget.cartService.createOrder(
                          selectedPaymentMethod!.idPayment,
                          selectedPaymentMethod!.name,
                          selectedToken,
                          _selectedDateTime!,
                          selectedDireccion!.direccionCompleta,
                          selectedDireccion!.latitude,
                          selectedDireccion!.longitude,
                          listProducts,
                          listCombos,
                          selectedCupon!.code,
                          instructions);
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
                  },
                  icon: Icon(
                    Icons.check_circle,
                    color: TColor.primary,
                  ),
                  label: Text(
                    'Confirmar Pedido',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: TColor.primary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    side: BorderSide(color: TColor.primary, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _validateFields() {
    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Por favor, seleccione una fecha."),
        ),
      );
      return false;
    }
    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Por favor, seleccione un método de pago."),
        ),
      );
      return false;
    }
    if (selectedDireccion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Por favor, seleccione una dirección."),
        ),
      );
      return false;
    }
    return true;
  }
}
