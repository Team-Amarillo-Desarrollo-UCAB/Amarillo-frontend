import 'package:desarrollo_frontend/Carrito/application/cart_useCase.dart';
import 'package:desarrollo_frontend/Carrito/presentation/cart_screen.dart';
import 'package:desarrollo_frontend/descuento/application/descuento_UseCase.dart';
import 'package:desarrollo_frontend/categorias/domain/category.dart';
import 'package:desarrollo_frontend/categorias/infrasestructure/category_service.dart';
import 'package:desarrollo_frontend/common/presentation/common_widget/category_cell.dart';
import 'package:desarrollo_frontend/common/presentation/main_tabview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../common/infrastructure/base_url.dart';
import '../../common/presentation/color_extension.dart';
import '../infrastructure/product_service.dart';
import '../infrastructure/product_service_search.dart';
import '../../Carrito/domain/cart_item.dart';
import '../domain/product.dart';
import 'product_widget.dart';

class ProductView extends StatefulWidget {
  final String? searchQuery;
  const ProductView({super.key, this.searchQuery});
  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  TextEditingController _searchController = TextEditingController();
  List<Category> _categories = [];
  List<Product> _product = [];
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isSearching = false;
  bool _initialLoadComplete = false;
  bool _searchLoadComplete = false;
  final CartUsecase _cartUsecase = CartUsecase();
  final DescuentoUsecase _descuentoUsecase = DescuentoUsecase();
  final ProductService _productService = ProductService(BaseUrl().BASE_URL);
  final ProductServiceSearch _productServiceSearch =
      ProductServiceSearch(BaseUrl().BASE_URL);
  final CategoryService _categoryService = CategoryService(BaseUrl().BASE_URL);
  Map<String, Future<double>> _discountedPriceFutures = {};

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
      _searchController.text = widget.searchQuery!;
      _searchProductByName(widget.searchQuery!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([_loadMoreProducts(), _loadCategories()]);
    setState(() {
      _initialLoadComplete = true;
    });
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
          final filteredProducts = newProducts
              .where((newProduct) => !_product.any((existingProduct) =>
                  existingProduct.id_product == newProduct.id_product))
              .toList();
          _product.addAll(filteredProducts);

          for (var product in filteredProducts) {
            _discountedPriceFutures[product.id_product] =
                _descuentoUsecase.getDiscountedPriceProduct(product);
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

  Future<void> _searchProductByName(String productName) async {
    setState(() {
      _isSearching = true;
      _searchLoadComplete = false;
      _product.clear();
      _discountedPriceFutures.clear();
      _page = 1;
      _hasMore = true;
    });

    String formattedProductName = Uri.encodeComponent(productName.trim());

    Future.delayed(Duration(seconds: 3), () {
      if (_isSearching) {
        setState(() {
          _searchLoadComplete = true;
          _isSearching = false;
        });
      }
    });

    try {
      Product product =
          await _productServiceSearch.getProductByName(formattedProductName);
      setState(() {
        _product = [product];
        _discountedPriceFutures[product.id_product] =
            _descuentoUsecase.getDiscountedPriceProduct(product);
        _isSearching = false;
        _searchLoadComplete = true;
      });
    } catch (error) {
      setState(() {
        _isSearching = false;
        _searchLoadComplete = true;
        _product.clear();
      });
      print('Error al buscar producto: $error');
    }
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
                MaterialPageRoute(builder: (context) => const MainTabView()));
          },
        ),
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
        onNotification: (ScrollNotification notification) {
          if (notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent &&
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
                                'id': category.categoryID,
                              },
                              onTap: () {},
                              isCombo: false,
                            );
                          }),
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
                (!_initialLoadComplete || _isSearching)
                    ? Center(child: CircularProgressIndicator())
                    : (_product.isEmpty && _searchLoadComplete)
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.network(
                                  "https://assets10.lottiefiles.com/packages/lf20_02epxjye.json",
                                  width: MediaQuery.of(context).size.width /
                                      4.5 *
                                      2.5,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Text(
                                    "No se ha encontrado el producto: '${_searchController.text}'",
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Colors.indigo,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _product.length,
                            itemBuilder: (context, index) {
                              final product = _product[index];
                              return FutureBuilder<double>(
                                future:
                                    _discountedPriceFutures[product.id_product],
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
                                      onAdd: () => _cartUsecase.onAddCart(
                                          CartItem(
                                            id_product: product.id_product,
                                            imageUrl: product.images[0],
                                            name: product.name,
                                            price: discountedPrice,
                                            description: product.description,
                                            peso: product.peso,
                                            isCombo: false,
                                            discount: product.discount,
                                            category: product.category,
                                          ),
                                          context),
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
