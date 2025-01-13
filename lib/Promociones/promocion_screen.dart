import 'package:desarrollo_frontend/Carrito/domain/cart_item.dart';
import 'package:desarrollo_frontend/Carrito/infrastructure/cart_service.dart';
import 'package:desarrollo_frontend/Carrito/presentation/cart_screen.dart';
import 'package:desarrollo_frontend/Combo/domain/combo.dart';
import 'package:desarrollo_frontend/Combo/infrastructure/combo_service.dart';
import 'package:desarrollo_frontend/Combo/presentation/combo_widget.dart';
import 'package:desarrollo_frontend/Descuento/Domain/descuento.dart';
import 'package:desarrollo_frontend/Descuento/Infrastructure/descuento_service.dart';
import 'package:desarrollo_frontend/Descuento/Infrastructure/descuento_service_search_by_id.dart';
import 'package:desarrollo_frontend/Producto/domain/product.dart';
import 'package:desarrollo_frontend/Producto/infrastructure/product_service.dart';
import 'package:desarrollo_frontend/Producto/presentation/product_widget.dart';
import 'package:desarrollo_frontend/common/infrastructure/base_url.dart';
import 'package:desarrollo_frontend/common/presentation/main_tabview.dart';
import 'package:flutter/material.dart';

import '../common/presentation/color_extension.dart';

class PromocionesView extends StatefulWidget {
  const PromocionesView({super.key});
  @override
  State<PromocionesView> createState() => _PromocionesViewState();
}

class _PromocionesViewState extends State<PromocionesView> {
  List<Combo> _combo = [];
  List<Descuento> _descuentos = [];
  List<Product> _products = [];
  bool _isLoading = true;
  bool _showCombo = true;
  final CartService _cartService = CartService();
  final ComboService _comboService = ComboService(BaseUrl().BASE_URL);
  final DescuentoService _descuentoService =
      DescuentoService(BaseUrl().BASE_URL);
  final DescuentoServiceSearchById _descuentoServiceSearchById =
      DescuentoServiceSearchById(BaseUrl().BASE_URL);
  final ProductService _productService = ProductService(BaseUrl().BASE_URL);
  @override
  void initState() {
    super.initState();
    _loadAllCombos();
    _loadAllProducts();
    _loadAllDescuentos();
  }

  Future<void> _loadAllCombos() async {
    int page = 1;
    bool hasMore = true;
    List<Combo> allCombos = [];
    while (hasMore) {
      try {
        List<Combo> combos = await _comboService.getCombo(page);
        if (combos.isEmpty) {
          hasMore = false;
        } else {
          allCombos.addAll(combos);
          page++;
        }
      } catch (error) {
        print('Error al obtener combos: $error');
        hasMore = false;
      }
    }
    setState(() {
      _combo = allCombos;
    });
  }

  Future<void> _loadAllProducts() async {
    int page = 1;
    bool hasMore = true;
    List<Product> allProducts = [];
    while (hasMore) {
      try {
        List<Product> products = await _productService.getProducts(page);
        if (products.isEmpty) {
          hasMore = false;
        } else {
          allProducts.addAll(products);
          page++;
        }
      } catch (error) {
        print('Error al obtener productos: $error');
        hasMore = false;
      }
    }
    setState(() {
      _products = allProducts;
      _isLoading = false;
    });
  }

  Future<void> _loadAllDescuentos() async {
    int page = 1;
    bool hasMore = true;
    List<Descuento> allDescuentos = [];
    while (hasMore) {
      try {
        List<Descuento> descuentos = await _descuentoService.getDescuento(page);
        if (descuentos.isEmpty) {
          hasMore = false;
        } else {
          allDescuentos.addAll(descuentos);
          page++;
        }
      } catch (error) {
        print('Error al obtener descuentos: $error');
        hasMore = false;
      }
    }
    allDescuentos.removeWhere(
        (descuento) => descuento.id == "9bd9532c-5033-4621-be8a-87de4934a0be");
    setState(() {
      _descuentos = allDescuentos;
    });
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

  Future<double> _getDiscountedPriceProduct(Product product) async {
    if (product.discount != "") {
      try {
        final descuento = await _descuentoServiceSearchById
            .getDescuentoById(product.discount);
        return double.parse(product.price) * (1 - descuento.percentage);
      } catch (error) {
        print('Error al obtener el descuento: $error');
      }
    }
    return double.parse(product.price);
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
        title: const Text('Promociones',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainTabView()));
            }),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: TColor.primary),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showCombo = true;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                _showCombo ? TColor.primary : TColor.placeholder,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Center(
                              child: Text(
                                "Combo",
                                style: TextStyle(
                                  color:
                                      _showCombo ? TColor.white : TColor.placeholder,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showCombo = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                !_showCombo ? TColor.primary : TColor.placeholder,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Center(
                              child: Text(
                                "Producto",
                                style: TextStyle(
                                  color:
                                      !_showCombo ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_showCombo)
                _combo.isEmpty
                    ? const Center(child: Text('No hay combos disponibles.'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _descuentos.length,
                        itemBuilder: (context, index) {
                          final descuento = _descuentos[index];
                          final combosConDescuento = _combo
                              .where((combo) => combo.discount == descuento.id)
                              .toList();
                          if (combosConDescuento.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                descuento.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: combosConDescuento.length,
                                itemBuilder: (context, index) {
                                  final combo = combosConDescuento[index];
                                  return FutureBuilder<double>(
                                    future: _getDiscountedPrice(combo),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
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
                                              category: combo.category)),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        },
                      )
              else
                _products.isEmpty
                    ? const Center(child: Text('No hay Productos disponibles.'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _descuentos.length,
                        itemBuilder: (context, index) {
                          final descuento = _descuentos[index];
                          final productConDescuento = _products
                              .where(
                                  (product) => product.discount == descuento.id)
                              .toList();
                          if (productConDescuento.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                descuento.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: productConDescuento.length,
                                itemBuilder: (context, index) {
                                  final product = productConDescuento[index];
                                  return FutureBuilder<double>(
                                    future: _getDiscountedPriceProduct(product),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
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
                                            category: product.category,
                                          )),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        },
                      )
            ],
          ),
        ),
      ),
    );
  }
}
