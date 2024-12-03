import 'package:desarrollo_frontend/domain/Carrito/cart_screen.dart';
import 'package:desarrollo_frontend/domain/main_tabview/main_tabview.dart';
import 'package:flutter/material.dart';
import '../../common/base_url.dart';
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
  TextEditingController _searchController = TextEditingController();

  // Declaramos las categorías para las etiquetas
  List<String> categories = ['Todos', 'Comida', 'Infantil', 'Completa'];
  String selectedCategory = 'Todos'; // Categoría seleccionada por defecto

  List<Product> _product = [];
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isSearching = false;

  final CartService _cartService = CartService();
  final ProductService _productService =
      ProductService(BaseUrl().BASE_URL); 
  final ProductServiceSearch _productServiceSearch = ProductServiceSearch(
      BaseUrl().BASE_URL);

  @override
  void initState() {
    super.initState();
    _loadMoreProducts(); // Llamada al backend para cargar productos al iniciar el widget
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoading || !_hasMore) return;
    setState(() {
      _isLoading = true;
    });
    try {
      List<Product> newProducts = await _productService.getProducts(_page);
      setState(() {
        if (newProducts.isEmpty) {
          _hasMore = false;
        } else {
          _product.addAll(newProducts);
          _page++;
        }
      });
    } catch (error) {
      print('Error al obtener productos: $error');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _searchProductByName(String productName) async {
    setState(() {
      _isSearching = true;
    });

    // Formateamos el nombre a título de caso
    String formattedProductName = productName
        .toLowerCase()
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');

    try {
      Product product =
          await _productServiceSearch.getProductByName(formattedProductName);
      setState(() {
        _product = [product];
      });
    } catch (error) {
      print('Error al buscar producto: $error');
    }
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      _searchProductByName(_searchController.text);
    } else {
      _resetSearch();
    }
  }

  void _resetSearch() {
    setState(() {
      _isSearching = false;
      _product.clear();
      _page = 1;
      _hasMore = true;
      _loadMoreProducts();
    });
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
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        centerTitle: true,
        title: const Text('Productos',
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
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification) {
          if (ScrollNotification.metrics.pixels ==
                  ScrollNotification.metrics.maxScrollExtent &&
              !_isSearching) {
            _loadMoreProducts();
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Buscador
                TextField(
                  controller: _searchController,
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
                    _searchProductByName(value);
                  },
                  onChanged: (value) {
                    if (value.isEmpty) {
                      _loadMoreProducts();
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
                        physics:
                            const NeverScrollableScrollPhysics(), // Para evitar el scroll dentro del ListView
                        itemCount: _product.length,
                        itemBuilder: (context, index) {
                          final product = _product[index];
                          return ProductCard(
                            product: product,
                            onAdd: () => onAdd(CartItem(
                                id_product: product.id_product,
                                imageUrl: product.image,
                                name: product.name,
                                price: product.price,
                                description: product.description,
                                peso: product.peso)),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
