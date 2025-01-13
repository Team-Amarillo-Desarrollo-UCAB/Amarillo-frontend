import 'package:desarrollo_frontend/Carrito/presentation/cart_screen.dart';
import 'package:desarrollo_frontend/Combo/domain/combo.dart';
import 'package:desarrollo_frontend/Combo/infrastructure/combo_service.dart';
import 'package:desarrollo_frontend/Combo/presentation/combo_widget.dart';
import 'package:desarrollo_frontend/Descuento/Infrastructure/descuento_service_search_by_id.dart';
import 'package:desarrollo_frontend/categorias/domain/category.dart';
import 'package:desarrollo_frontend/categorias/infrasestructure/category_service.dart';
import 'package:desarrollo_frontend/common/infrastructure/base_url.dart';
import 'package:desarrollo_frontend/common/presentation/common_widget/category_cell.dart';
import 'package:desarrollo_frontend/common/presentation/main_tabview.dart';
import 'package:flutter/material.dart';
import '../../Carrito/domain/cart_item.dart';
import '../../Carrito/infrastructure/cart_service.dart';
import '../../common/presentation/color_extension.dart';

class ComboView extends StatefulWidget {
  const ComboView({super.key});
  @override
  State<ComboView> createState() => _ComboViewState();
}

class _ComboViewState extends State<ComboView> {
  List<Category> _categories = [];
  List<Combo> _combo = [];
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isSearching = false;
  final CartService _cartService = CartService();
  final ComboService _comboService = ComboService(BaseUrl().BASE_URL);
  final CategoryService _categoryService = CategoryService(BaseUrl().BASE_URL);
  final DescuentoServiceSearchById _descuentoServiceSearchById =
      DescuentoServiceSearchById(BaseUrl().BASE_URL);
  Map<String, Future<double>> _discountedPriceFutures = {};
  @override
  void initState() {
    super.initState();
    _loadMoreProducts();
    _loadCategories();
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoading || !_hasMore) return;
    setState(() {
      _isLoading = true;
    });
    try {
      List<Combo> newProducts = await _comboService.getCombo(_page);
      setState(() {
        if (newProducts.isEmpty) {
          _hasMore = false;
        } else {
          _combo.addAll(newProducts);
          for (var combo in newProducts) {
            _discountedPriceFutures[combo.id_product] =
                _getDiscountedPrice(combo);
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

  Future<double> _getDiscountedPrice(Combo combo) async {
    if (combo.discount != "") {
      try {
        final descuento =
            await _descuentoServiceSearchById.getDescuentoById(combo.discount);
        return double.parse(combo.price) * (1 - descuento.percentage);
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: TColor.secondary,
          centerTitle: true,
          title: const Text('Combos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainTabView()));
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
                                  'id': category.categoryID,
                                },
                                onTap: () {},
                                isCombo: true,
                              );
                            }),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "${_combo.length} Resultados",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _combo.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _combo.length,
                          itemBuilder: (context, index) {
                            final combo = _combo[index];
                            return FutureBuilder<double>(
                              future: _discountedPriceFutures[combo.id_product],
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
                                      productId: combo.productId,
                                      isCombo: true,
                                      discount: combo.discount,
                                      category: combo.category,
                                    )),
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
        ));
  }
}
