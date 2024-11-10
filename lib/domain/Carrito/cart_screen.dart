
import 'package:flutter/material.dart';
import 'cart_item.dart';
import 'cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> _cartItems = [
    CartItem(
      imageUrl: const NetworkImage('https://www.harinarepa.com/web/image/product.template/401/image_256/%5BHARPANBLANC%5D%20Harina%20Pan%20Blanca?unique=d192c25'),
      name: 'Harina Pan',
      price: 10.5,
      description: '1 kg',
    ),
    CartItem(
      imageUrl: const NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgUqCgTNTnh9nIX_FnzrDfssfSaGMb9PVeMQ&s'),
      name: 'Nestle - Limón',
      price: 1.5,
      description: '120 gr',
    ),
    CartItem(
      imageUrl: const NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgUqCgTNTnh9nIX_FnzrDfssfSaGMb9PVeMQ&s'),
      name: 'Nestle - Durazno',
      price: 1.5,
      description: '120 gr',
    ),
    CartItem(
      imageUrl: const NetworkImage('https://images.rappi.com/products/ccb54d3a-0595-4627-bdbf-2c95887555ff.png?e=webp&q=80&d=130x130'),
      name: 'Almuerzo Familiar',
      price: 30.0,
      description: 'Combo',
    ),
    CartItem(
      imageUrl: const NetworkImage('https://images.rappi.com/products/ccb54d3a-0595-4627-bdbf-2c95887555ff.png?e=webp&q=80&d=130x130'),
      name: 'Almuerzo Familiar',
      price: 25.0,
      description: 'Combo',
    ),
    CartItem(
      imageUrl: const NetworkImage('https://images.rappi.com/products/ccb54d3a-0595-4627-bdbf-2c95887555ff.png?e=webp&q=80&d=130x130'),
      name: 'Almuerzo',
      price: 32.0,
      description: 'Combo',
    ), // Agrega más productos aquí
  ];

  double get _totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

void _incrementItemQuantity(CartItem item) {
    setState(() {
      item.incrementQuantity();
    });
  }

  void _decrementItemQuantity(CartItem item) {
    setState(() {
      item.decrementQuantity();
    });
  }

  void _removeItem(CartItem item) {
    setState(() {
      item.eliminateQuantity();
      _cartItems.remove(item);
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
          onPressed: () => Navigator.pop(context), 
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
                  onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
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

