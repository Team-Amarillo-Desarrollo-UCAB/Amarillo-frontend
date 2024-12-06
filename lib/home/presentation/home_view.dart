import 'package:desarrollo_frontend/Combo/domain/combo.dart';
import 'package:desarrollo_frontend/Combo/infrastructure/combo_service.dart';
import 'package:desarrollo_frontend/Combo/presentation/combo_view.dart';
import 'package:desarrollo_frontend/Combo/presentation/combo_widget.dart';
import 'package:desarrollo_frontend/Descuento/Domain/descuento.dart';
import 'package:desarrollo_frontend/Descuento/Infrastructure/descuento_service.dart';
import 'package:desarrollo_frontend/Descuento/Infrastructure/descuento_service_search_by_id.dart';
import 'package:desarrollo_frontend/categorias/domain/category.dart';
import 'package:desarrollo_frontend/categorias/infrasestructure/category_service.dart';
import 'package:desarrollo_frontend/categorias/presentation/category_items_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Users/domain/user_profile.dart';
import '../../common/infrastructure/base_url.dart';
import '../../common/presentation/color_extension.dart';
import '../../common/presentation/common_widget/category_cell.dart';
import '../../common/presentation/common_widget/most_popular_cell.dart';
import '../../common/presentation/common_widget/round_textfield.dart';
import '../../common/presentation/common_widget/view_all_title_row.dart';
import '../../Producto/infrastructure/product_service.dart';
import '../../Carrito/domain/cart_item.dart';
import '../../Carrito/infrastructure/cart_service.dart';
import '../../Producto/domain/popular_product.dart';
import '../../Producto/presentation/popular_product_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController _searchController = TextEditingController();
  List<Product> _product = [];
  List<Combo> _combo = [];
  List<Category> _categories = [];
  List<Descuento> _descuentos = [];

  final CartService _cartService = CartService();
  final ProductService _productService = ProductService(BaseUrl().BASE_URL);
  final ComboService _comboService = ComboService(BaseUrl().BASE_URL);
  final DescuentoServiceSearchById _descuentoServiceSearchById =
      DescuentoServiceSearchById(BaseUrl().BASE_URL);
  final DescuentoService _descuentoService =
      DescuentoService(BaseUrl().BASE_URL);
  final CategoryService _categoryService = CategoryService(BaseUrl().BASE_URL);

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchCombos();
    _fetchCategories();
    _fetchDescuentos();
  }

  Future<void> _fetchProducts() async {
    try {
      List<Product> products = await _productService.getProducts(1);
      setState(() {
        _product = products;
        _product.shuffle();
        _product = _product.take(5).toList();
      });
    } catch (error) {
      print('Error al obtener productos: $error');
    }
  }

  Future<void> _fetchCombos() async {
    try {
      List<Combo> Combos = await _comboService.getCombo(1);
      setState(() {
        _combo = Combos;
        _combo.shuffle();
        _combo = _combo.take(5).toList();
      });
    } catch (error) {
      print('Error al obtener productos: $error');
    }
  }

  Future<void> _fetchCategories() async {
    try {
      List<Category> categories = await _categoryService.getCategories(1);
      setState(() {
        _categories = categories;
      });
    } catch (error) {
      print('Error al obtener categorías: $error');
    }
  }

  Future<void> _fetchDescuentos() async {
    try {
      List<Descuento> descuentos = await _descuentoService.getDescuento(1);
      setState(() {
        _descuentos = descuentos;
        _descuentos.shuffle();
        _descuentos = _descuentos.take(5).toList();
      });
    } catch (error) {
      print('Error al obtener descuentos: $error');
    }
  }

  Future<double> _getDiscountedPrice(Combo combo) async {
    if (combo.discount != "9bd9532c-5033-4621-be8a-87de4934a0be") {
      try {
        final descuento =
            await _descuentoServiceSearchById.getDescuentoById(combo.discount);
        return double.parse(combo.price) * (1 - descuento.percentage / 100);
      } catch (error) {
        print('Error al obtener el descuento: $error');
      }
    }
    return double.parse(combo.price);
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
    var media = MediaQuery.of(context).size;
    final userProfile = Provider.of<UserProfile>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: media.height * 0.02),
          child: Column(
            children: [
              SizedBox(height: media.height * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: media.width * 0.05),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/img/perfil.png',
                        width: media.width * 0.12,
                        height: media.width * 0.12,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: media.width * 0.03),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¡HOLA ${userProfile.name.toUpperCase()}!',
                          style: TextStyle(
                              color: TColor.primary,
                              fontSize: media.width * 0.04,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Sábana Grande, Caracas",
                          style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: media.width * 0.035,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: media.height * 0.015),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: media.width * 0.05),
                child: TextField(
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
                    if (value.trim().isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductListView(searchQuery: value.trim()),
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: media.height * 0.03),
              _descuentos.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: media.height * 0.17,
                      child: PageView.builder(
                        itemCount: _descuentos.length,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            child: Image.network(
                              _descuentos[index].image,
                              width: media.width * 0.9,
                              height: media.height * 0.17,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: media.width * 0.05),
                child: ViewAllTitleRow(
                  title: "Categorías",
                  onView: () {},
                ),
              ),
              SizedBox(
                height: media.height * 0.13,
                child: _categories.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                            horizontal: media.width * 0.03),
                        itemCount: _categories.length,
                        itemBuilder: ((context, index) {
                          final category = _categories[index];
                          return CategoryCell(
                            cObj: {
                              'image': category.categoryImage,
                              'name': category.categoryName,
                            },
                            onTap: () {},
                          );
                        }),
                      ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: media.width * 0.05),
                child: ViewAllTitleRow(
                  title: "Oferta de Combos",
                  onView: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ComboView()));
                  },
                ),
              ),
              SizedBox(
                height: media.height * 0.22,
                child: _combo.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : PageView.builder(
                        itemCount: _combo.length,
                        itemBuilder: (context, index) {
                          final combo = _combo[index];
                          return FutureBuilder<double>(
                            future: _getDiscountedPrice(combo),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final discountedPrice = snapshot.data!;
                                return ComboCard(
                                  combo: combo,
                                  onAdd: () => onAdd(CartItem(
                                      id_product: combo.id_product,
                                      imageUrl: combo.images[0],
                                      name: combo.name,
                                      price: discountedPrice,
                                      description: combo.description,
                                      peso: combo.peso,
                                      productId: combo.productId)),
                                );
                              }
                            },
                          );
                        },
                      ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: media.width * 0.05),
                child: ViewAllTitleRow(
                  title: "Productos Populares",
                  onView: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductListView()));
                  },
                ),
              ),
              SizedBox(
                height: media.height * 0.19,
                child: _product.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : PageView.builder(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
