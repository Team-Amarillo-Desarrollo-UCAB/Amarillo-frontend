import 'package:desarrollo_frontend/Carrito/cart_screen.dart';
import 'package:desarrollo_frontend/Combo/combo.dart';
import 'package:desarrollo_frontend/Combo/combo_widget.dart';
import 'package:desarrollo_frontend/main_tabview/main_tabview.dart';
import 'package:flutter/material.dart';
import '../Carrito/cart_item.dart';
import '../Carrito/cart_service.dart';

class ComboView extends StatefulWidget {
  const ComboView({super.key});

  @override
  State<ComboView> createState() => _ComboViewState();
}

class _ComboViewState extends State<ComboView> {
  Combo comboFamiliarEconomico = Combo(
    id_combo: 'C006',
    image: NetworkImage(
        'https://res.cloudinary.com/dxttqmyxu/image/upload/v1731483047/kkizccq7zv9j37jg0hi3.png'),
    name: 'Familiar Económico',
    price: 35.99,
    description: [
      '2 kg de Arroz',
      '1 kg de Fideos',
      '1 kg de Azúcar',
      '1 L de Aceite',
      '1 lata de Atún',
      '1 kg de Papas',
    ],
    peso: '5 kg',
  );

  Combo verdurasYFrutas = Combo(
    id_combo: 'C007',
    image: NetworkImage(
        'https://res.cloudinary.com/dxttqmyxu/image/upload/v1731483047/kkizccq7zv9j37jg0hi3.png'),
    name: 'Verduras y Frutas',
    price: 20.99,
    description: [
      '1 kg de Tomates',
      '1 kg de Cebolla',
      '500g de Zanahorias',
      '1 lechuga',
      '1 kg de Manzanas',
      '500g de Uvas',
    ],
    peso: '3 kg',
  );

  Combo desayuno = Combo(
    id_combo: 'C008',
    image: NetworkImage(
        'https://res.cloudinary.com/dxttqmyxu/image/upload/v1731483047/kkizccq7zv9j37jg0hi3.png'),
    name: 'Desayuno',
    price: 12.49,
    description: [
      '500g de Café',
      '250g de Té',
      '500g de Galletas',
      '250g de Mermelada',
      '100g de Miel',
    ],
    peso: '1.5 kg',
  );

  Combo limpieza = Combo(
    id_combo: 'C009',
    image: NetworkImage(
        'https://res.cloudinary.com/dxttqmyxu/image/upload/v1731483047/kkizccq7zv9j37jg0hi3.png'),
    name: 'Limpieza',
    price: 18.99,
    description: [
      'Detergente para ropa (1 L)',
      'Jabón para platos (500 ml)',
      'Suavizante (1 L)',
      'Blanqueador (500 ml)',
      'Esponja',
    ],
    peso: '3 kg',
  );

  Combo carnes = Combo(
    id_combo: 'C010',
    image: NetworkImage(
        'https://res.cloudinary.com/dxttqmyxu/image/upload/v1731483047/kkizccq7zv9j37jg0hi3.png'),
    name: 'Carnes',
    price: 39.99,
    description: [
      '1 kg de Filete de Res',
      '1 kg de Pechuga de Pollo',
      '500g de Chorizo',
      '500g de Salchicha',
    ],
    peso: '3 kg',
  );

  // Lista de productos que se llena desde el backend
  List<Combo> _combos = [];

  void AgregarProductos() {
    _combos.add(comboFamiliarEconomico);
    _combos.add(verdurasYFrutas);
    _combos.add(desayuno);
    _combos.add(limpieza);
    _combos.add(carnes);
  }

  @override
  void initState() {
    super.initState();
    AgregarProductos();
  }

  final CartService _cartService = CartService();

  void onAdd(CartItem item) async {
    await _cartService.loadCartItems(); // Carga los elementos del carrito
    bool isProductInCart = _cartService.cartItems.any((cartItem) =>
        cartItem.name ==
        item.name); // Verifica si el producto ya está en el carrito
    if (isProductInCart) {
      CartItem existingItem = _cartService.cartItems
          .firstWhere((cartItem) => cartItem.name == item.name);
      existingItem.incrementQuantity();
    } else {
      // Si el producto no está en el carrito, lo añade
      _cartService.cartItems.add(item);
    }
    await _cartService.saveCartItems(); // Guarda los cambios en el carrito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isProductInCart
            ? '${item.name} cantidad incrementada'
            : '${item.name} añadido al carrito'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        centerTitle: true,
        title: const Text('Combos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainTabView()));
            }),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.orange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20), // Espaciado superior
              // Número de resultados
              Text(
                "${_combos.length} Resultados",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Para evitar el scroll dentro del ListView
                itemCount: _combos.length,
                itemBuilder: (context, index) {
                  final combo = _combos[index];
                  return ComboCard(
                    combo: combo,
                    onAdd: () => onAdd(CartItem(
                        id_product: combo.id_combo,
                        imageUrl: combo.image,
                        name: combo.name,
                        price: combo.price,
                        description: combo.description,
                        peso: combo.peso)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
