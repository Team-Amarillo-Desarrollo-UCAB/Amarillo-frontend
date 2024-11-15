
import 'package:flutter/material.dart';
import '../../infrastructure/product_service.dart';
import '../../infrastructure/product_service_search.dart';
import '../Carrito/cart_item.dart';
import '../Carrito/cart_service.dart';
import '../home/popular_product.dart';
import '../home/popular_product_widget.dart';


class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  TextEditingController txtSearch = TextEditingController();
  
  // Declaramos las categorías para las etiquetas
  List<String> categories = ['Todos', 'Comida', 'Infantil', 'Completa'];
  String selectedCategory = 'Todos'; // Categoría seleccionada por defecto

  // Lista de productos que se llena desde el backend
  List<Product> _product = [];
  final CartService _cartService = CartService();
  final ProductService _productService = ProductService('https://amarillo-backend-production.up.railway.app');
  final ProductServiceSearch _productServiceSearch = ProductServiceSearch('https://amarillo-backend-production.up.railway.app');

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Llamada al backend para cargar productos al iniciar el widget
  }

  Future<void> _fetchProducts() async {
    try {
      List<Product> products = await _productService.getProducts();
      setState(() {
        _product = products;
      });
    } catch (error) {
      print('Error al obtener productos: $error');
    }
  }

  Future<void> _searchProductByName(String productName) async {
    try {
      Product product = await _productServiceSearch.getProductByName(productName);
      setState(() {
        _product = [product];
      });
    } catch (error) {
      print('Error al buscar producto: $error');
    }
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 46), // Espaciado superior
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Productos",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Buscador
              TextField(
                controller: txtSearch,
                decoration: InputDecoration(
                  hintText: "Productos, Categorías...",
                  prefixIcon: const Icon(Icons.search, color: Colors.orange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.orange.withOpacity(0.1),
                ),
                onSubmitted: (value) {
                  _searchProductByName(value);},
                onChanged: (value) {
                  if (value.isEmpty) {
                    _fetchProducts();
                  }
                },
              ),
              const SizedBox(height: 15),
              // Etiquetas de categorías
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    String category = categories[index];
                    bool isSelected = category == selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        selectedColor: Colors.orange,
                        backgroundColor: Colors.orange.withOpacity(0.2),
                        onSelected: (bool selected) {
                          setState(() {
                            selectedCategory = category;
                          });
                          // Aquí puedes agregar la lógica de filtrado
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              // Número de resultados
              Text(
                "${_product.length} Resultados",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Lista de Productos obtenidos del backend
              _product.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), // Para evitar el scroll dentro del ListView
                      itemCount: _product.length,
                      itemBuilder: (context, index) {
                        final product = _product[index];
                        return ProductCard(
                          product: product,
                          onAdd: () => onAdd(CartItem(
                        imageUrl: product.image,
                        name: product.name,
                        price: product.price,
                        description: product.peso,
                      )),
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
