import 'package:desarrollo_frontend/Carrito/domain/cart_item.dart';
import 'package:desarrollo_frontend/Carrito/infrastructure/cart_service.dart';
import 'package:desarrollo_frontend/Carrito/presentation/cart_screen.dart';
import 'package:desarrollo_frontend/Descuento/Infrastructure/descuento_service_search_by_id.dart';
import 'package:desarrollo_frontend/Producto/domain/product.dart';
import 'package:desarrollo_frontend/Producto/infrastructure/product_category_service.dart';
import 'package:desarrollo_frontend/Producto/infrastructure/product_service_search.dart';
import 'package:desarrollo_frontend/Producto/presentation/product_widget.dart';
import 'package:desarrollo_frontend/Producto/presentation/product_view.dart';
import 'package:desarrollo_frontend/categorias/domain/category.dart';
import 'package:desarrollo_frontend/categorias/infrasestructure/category_service.dart';
import 'package:desarrollo_frontend/common/infrastructure/base_url.dart';
import 'package:flutter/material.dart';
import '../../common/presentation/color_extension.dart';
import '../../common/presentation/common_widget/category_cell.dart';

class CategoriasProductView extends StatefulWidget {
  final String? searchQuery;
  final String idCategory;
  final String idName;
  const CategoriasProductView(
      {super.key,
      required this.idCategory,
      required this.idName,
      this.searchQuery});

  @override
  State<CategoriasProductView> createState() => _CategoriasProductViewState();
}

class _CategoriasProductViewState extends State<CategoriasProductView> {
  TextEditingController _searchController = TextEditingController();
  List<Category> _categories = [];
  List<Product> _product = [];
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isSearching = false;
  final CartService _cartService = CartService();
  final ProductCategoryService _productService =
      ProductCategoryService(BaseUrl().BASE_URL);
  final ProductServiceSearch _productServiceSearch =
      ProductServiceSearch(BaseUrl().BASE_URL);
  final CategoryService _categoryService = CategoryService(BaseUrl().BASE_URL);
  final DescuentoServiceSearchById _descuentoServiceSearchById =
      DescuentoServiceSearchById(BaseUrl().BASE_URL);
  Map<String, Future<double>> _discountedPriceFutures = {};

  @override
  void initState() {
    super.initState();
    _loadMoreProducts();
    _loadCategories();
    _searchController.addListener(_onSearchChanged);
    if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
      _searchController.text = widget.searchQuery!;
      _searchProductByName(widget.searchQuery!);
    } else {
      _loadMoreProducts();
    }
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
      List<Product> newProducts =
          await _productService.getProducts(_page, [widget.idCategory]);
      setState(() {
        if (newProducts.isEmpty) {
          _hasMore = false;
        } else {
          _product.addAll(newProducts);
          for (var product in newProducts) {
            _discountedPriceFutures[product.id_product] =
                _getDiscountedPrice(product);
          }
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

  Future<void> _loadCategories() async {
    try {
      List<Category> categories = await _categoryService.getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (error) {
      print('Error al obtener categorías: $error');
    }
  }

  Future<double> _getDiscountedPrice(Product product) async {
    if (product.discount != "") {
      try {
        final descuento = await _descuentoServiceSearchById
            .getDescuentoById(product.discount);
        final now = DateTime.now();

        if (now.isBefore(descuento.fechaExp)) {
          return double.parse(product.price) * (1 - descuento.percentage);
        } else {
          print(
              'El descuento no es válido porque la fecha de expedición es posterior a la fecha actual.');
        }
      } catch (error) {
        print('Error al obtener el descuento: $error');
      }
    }
    return double.parse(product.price);
  }

  Future<void> _searchProductByName(String productName) async {
    setState(() {
      _isSearching = true;
      _product.clear();
    });

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
        _isSearching = false;
      });
    } catch (error) {
      setState(() {
        _isSearching = false;
        _product.clear();
      });
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
    await _cartService.loadCartItems();
    bool isProductInCart =
        _cartService.cartItems.any((cartItem) => cartItem.name == item.name);
    if (isProductInCart) {
      CartItem existingItem = _cartService.cartItems
          .firstWhere((cartItem) => cartItem.name == item.name);
      existingItem.incrementQuantity();
    } else {
      _cartService.cartItems.add(item);
    }
    await _cartService.saveCartItems();
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
        backgroundColor: TColor.secondary,
        centerTitle: true,
        title: const Text('Productos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProductView()));
            }),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: TColor.black),
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
                    prefixIcon: Icon(Icons.search, color: TColor.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: TColor.secondary.withOpacity(0.4),
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
                SizedBox(
                  height: 120,
                  child: _categories.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          itemCount: _categories.length,
                          itemBuilder: ((context, index) {
                            final category = _categories[index];
                            return CategoryCell(
                              cObj: {
                                'image': category.categoryImage,
                                'name': category.categoryName,
                                'id': category.categoryID
                              },
                              onTap: () {},
                              isCombo: false,
                            );
                          }),
                        ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Categoria: ${widget.idName}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "${_product.length} Resultados",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _product.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _product.length,
                        itemBuilder: (context, index) {
                          final product = _product[index];
                          return FutureBuilder<double>(
                            future: _discountedPriceFutures[product.id_product],
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final discountedPrice = snapshot.data!;
                                return ProductCard2(
                                  product: product,
                                  onAdd: () => onAdd(CartItem(
                                      id_product: product.id_product,
                                      imageUrl: product.images[0],
                                      name: product.name,
                                      price: discountedPrice,
                                      description: product.description,
                                      peso: product.peso,
                                      isCombo: false,
                                      discount: product.discount,
                                      category: product.category)),
                                );
                              }
                            },
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
