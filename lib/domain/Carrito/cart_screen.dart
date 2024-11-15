import 'package:desarrollo_frontend/domain/Checkout/checkout_screen.dart';
import 'package:flutter/material.dart';
import '../main_tabview/main_tabview.dart';
import 'cart_item.dart';
import 'cart_item_widget.dart';
import 'cart_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService =
      CartService(); // Instancia única de CartService
  List<CartItem> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    await _cartService.loadCartItems();
    setState(() {
      _cartItems = _cartService.cartItems;
    });
  }

  double get _totalPrice {
    return _cartItems.fold(
        0, (sum, item) => sum + (item.price * item.quantity));
  }

  void _incrementItemQuantity(CartItem item) {
    setState(() {
      item.incrementQuantity();
      CartService().saveCartItems();
    });
  }

  void _decrementItemQuantity(CartItem item) {
    setState(() {
      item.decrementQuantity();
      CartService().saveCartItems();
    });
  }

  void _removeItem(CartItem item) {
    setState(() {
      _cartItems.remove(item);
      CartService().saveCartItems();
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
      CartService().clearCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.grey[200],
          centerTitle: true,
          title: const Text('Carrito de Compras',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainTabView()));
              })),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return CartItemWidget(
                  item: item,
                  onAdd: () => _incrementItemQuantity(item),
                  onRemove: () => _decrementItemQuantity(item),
                  onRemoveItem: () => _removeItem(item),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('${_totalPrice.toStringAsFixed(2)}\$')
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Descuento'),
                    Text('0.00\$'),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('${_totalPrice.toStringAsFixed(2)}\$',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await _cartService.createOrder(_cartItems);
                      // Mostrar un diálogo de confirmación
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('¡Orden creada con éxito!'),
                          content: const Text(
                              'Tu pedido ha sido procesado. Pronto recibirás una confirmación.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                _clearCart();
                                Navigator.of(context)
                                    .pop(); // Cerrar el diálogo
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutScreen(
                                      totalItems: _cartItems.length,
                                      totalPrice: _totalPrice,
                                    ),
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
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Proceder a la orden',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
