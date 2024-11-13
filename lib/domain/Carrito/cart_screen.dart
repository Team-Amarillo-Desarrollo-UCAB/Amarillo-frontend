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
  final CartService _cartService = CartService(); // Instancia única de CartService
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
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
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


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.grey[200],
      centerTitle: true,
      title: const Text('Carrito de Compras', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () { 
          Navigator.push( 
          context, 
          MaterialPageRoute( 
          builder: (context) => const MainTabView()));}  
        )),
      
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
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('${_totalPrice.toStringAsFixed(2)}\$')
                  ],
                ),
                const Row( 
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Text('Descuento'),
                    Text('0.00\$'),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('${_totalPrice.toStringAsFixed(2)}\$',style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('Proceder al Check-out')
                ),
              ],
            ),
          )  
        ],
      ),
    );
  }
}

