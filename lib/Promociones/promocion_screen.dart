import 'package:desarrollo_frontend/Carrito/domain/cart_item.dart';
import 'package:desarrollo_frontend/Carrito/infrastructure/cart_service.dart';
import 'package:desarrollo_frontend/Carrito/presentation/cart_screen.dart';
import 'package:desarrollo_frontend/Combo/domain/combo.dart';
import 'package:desarrollo_frontend/Combo/infrastructure/combo_service.dart';
import 'package:desarrollo_frontend/Combo/presentation/combo_widget.dart';
import 'package:desarrollo_frontend/Descuento/Domain/descuento.dart';
import 'package:desarrollo_frontend/Descuento/Infrastructure/descuento_service.dart';
import 'package:desarrollo_frontend/Descuento/Infrastructure/descuento_service_search_by_id.dart';
import 'package:desarrollo_frontend/common/infrastructure/base_url.dart';
import 'package:desarrollo_frontend/common/presentation/main_tabview.dart';
import 'package:flutter/material.dart';

class PromocionesView extends StatefulWidget {
  const PromocionesView({super.key});
  @override
  State<PromocionesView> createState() => _PromocionesViewState();
}

class _PromocionesViewState extends State<PromocionesView> {
  List<Combo> _combo = [];
  List<Descuento> _descuentos = [];
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final CartService _cartService = CartService();
  final ComboService _comboService = ComboService(BaseUrl().BASE_URL);
  final DescuentoService _descuentoService =
      DescuentoService(BaseUrl().BASE_URL);
  final DescuentoServiceSearchById _descuentoServiceSearchById =
      DescuentoServiceSearchById(BaseUrl().BASE_URL);
  @override
  void initState() {
    super.initState();
    _loadMoreProducts();
    _loadAllDescuentos();
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
          backgroundColor: Colors.grey[200],
          centerTitle: true,
          title: const Text('Promociones',
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
                ScrollNotification.metrics.maxScrollExtent) {
              //_loadMoreProducts();
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
                  _combo.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _descuentos.length,
                          itemBuilder: (context, index) {
                            final descuento = _descuentos[index];
                            final combosConDescuento = _combo
                                .where(
                                    (combo) => combo.discount == descuento.id)
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
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          final discountedPrice =
                                              snapshot.data!;
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
                                const SizedBox(height: 20),
                              ],
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
