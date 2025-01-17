import 'package:desarrollo_frontend/Carrito/application/cart_useCase.dart';
import 'package:desarrollo_frontend/Combo/domain/combo.dart';
import 'package:desarrollo_frontend/Combo/infrastructure/combo_popular_service.dart';
import 'package:desarrollo_frontend/Combo/presentation/combo_view.dart';
import 'package:desarrollo_frontend/Combo/presentation/combo_widget.dart';
import 'package:desarrollo_frontend/descuento/application/descuento_UseCase.dart';
import 'package:desarrollo_frontend/descuento/domain/descuento.dart';
import 'package:desarrollo_frontend/descuento/infrastructure/descuento_service.dart';
import 'package:desarrollo_frontend/Producto/infrastructure/product_popular_service.dart';
import 'package:desarrollo_frontend/descuento/presentation/promocion_screen.dart';
import 'package:desarrollo_frontend/categorias/domain/category.dart';
import 'package:desarrollo_frontend/categorias/infrasestructure/category_service.dart';
import 'package:desarrollo_frontend/Producto/presentation/product_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Cupon/presentation/cupon_screen.dart';
import '../../Users/domain/user_profile.dart';
import '../../Users/presentation/notification_screen.dart';
import '../../chatbot/prueba2.dart';
import '../../common/infrastructure/base_url.dart';
import '../../common/presentation/color_extension.dart';
import '../../common/presentation/common_widget/category_cell.dart';
import '../../common/presentation/common_widget/view_all_title_row.dart';
import '../../Carrito/domain/cart_item.dart';
import '../../Producto/domain/product.dart';
import '../../Producto/presentation/product_widget.dart';
import '../../common/presentation/logout_dialog.dart';
import 'paralax_background.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double stopParallaxHeight = 200;
  double stopParallaxHeight2 = 0;
  double topEleven = 0;
  double topTen = 0;
  double topNine = 0;
  double topEight = 0;
  double topSeven = 0;
  double topSix = 0;
  double topFive = 0;
  double topFour = 0;
  double topThree = 0;
  double topTwo = 0;
  double topOne = 0;
  TextEditingController _searchController = TextEditingController();
  List<Product> _product = [];
  List<Combo> _combo = [];
  List<Category> _categories = [];
  List<Descuento> _descuentos = [];
  late UserProfile userProfile = Provider.of<UserProfile?>(context)!;
  final CartUsecase _cartUsecase = CartUsecase();
  final DescuentoUsecase _descuentoUsecase = DescuentoUsecase();
  final ProductPopularService _productService =
      ProductPopularService(BaseUrl().BASE_URL);
  final ComboPopularService _comboService =
      ComboPopularService(BaseUrl().BASE_URL);
  final DescuentoService _descuentoService =
      DescuentoService(BaseUrl().BASE_URL);
  final CategoryService _categoryService = CategoryService(BaseUrl().BASE_URL);
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfile = Provider.of<UserProfile>(context, listen: false);
      userProfile.reloadFromPreferences().then((_) {
        setState(() {}); // Forzar reconstrucción
      });
    });
    _fetchProducts();
    _fetchCombos();
    _fetchCategories();
    _fetchDescuentos();
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

  Future<void> _fetchCombos() async {
    try {
      List<Combo> Combos = await _comboService.getCombo();
      setState(() {
        _combo = Combos;
      });
    } catch (error) {
      print('Error al obtener productos: $error');
    }
  }

  Future<void> _fetchCategories() async {
    try {
      List<Category> categories = await _categoryService.getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (error) {
      print('Error al obtener categorías: $error');
    }
  }

  Future<void> _fetchDescuentos() async {
    try {
      List<Descuento> descuentos = await _descuentoService.getDescuento();
      setState(() {
        _descuentos = descuentos;
      });
    } catch (error) {
      print('Error al obtener descuentos: $error');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProfile = Provider.of<UserProfile>(context, listen: false);
    userProfile.reloadFromPreferences();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    didChangeDependencies();
    return Stack(children: [
      // Drawer personalizado
      _buildDrawer(),
      AnimatedContainer(
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(isDrawerOpen ? 0.85 : 1.00),
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            borderRadius:
                isDrawerOpen ? BorderRadius.circular(30) : BorderRadius.zero,
          ),
          child: Scaffold(
            body: NotificationListener(
              onNotification: (notif) {
                if (notif is ScrollUpdateNotification) {
                  if (notif.scrollDelta == null) return true;
                  if (notif.scrollDelta != null &&
                      notif.metrics.axis == Axis.vertical &&
                      notif.metrics.pixels <= stopParallaxHeight) {
                    setState(() {
                      topEleven -= notif.scrollDelta! / 2.0;
                      topTen -= notif.scrollDelta! / 1.9;
                      topNine -= notif.scrollDelta! / 1.8;
                      topEight -= notif.scrollDelta! / 1.7;
                      topSeven -= notif.scrollDelta! / 1.6;
                      topSix -= notif.scrollDelta! / 1.5;
                      topFive -= notif.scrollDelta! / 1.4;
                      topFour -= notif.scrollDelta! / 1.3;
                      topThree -= notif.scrollDelta! / 1.2;
                      topTwo -= notif.scrollDelta! / 1.2;
                      topOne -= notif.scrollDelta! / 1;
                    });
                  }
                  if (notif.metrics.pixels <= stopParallaxHeight) {}
                }
                return true;
              },
              child: Stack(children: [
                // Parallax
                ParalaxBackground(
                  top: topSeven,
                  asset: 'assets/img/top-paralax-7.png',
                ),
                ParalaxBackground(
                  top: topTwo,
                  asset: 'assets/img/top-paralax-2.png',
                ),
                ParalaxBackground(
                  top: topNine,
                  asset: 'assets/img/top-paralax-9.png',
                ),
                ParalaxBackground(
                  top: topFive,
                  asset: 'assets/img/top-paralax-5.png',
                ),

                ParalaxBackground(
                  top: topEight,
                  asset: 'assets/img/top-paralax-8.png',
                ),
                ParalaxBackground(
                  top: topOne,
                  asset: 'assets/img/top-paralax-1.png',
                ),

                ParalaxBackground(
                  top: topFour,
                  asset: 'assets/img/top-paralax-4.png',
                ),
                ParalaxBackground(
                  top: topThree,
                  asset: 'assets/img/top-paralax-3.png',
                ),

                ParalaxBackground(
                  top: topSix,
                  asset: 'assets/img/top-paralax-6.png',
                ),
                SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(children: [
                    const SizedBox(height: 350),
                    NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels > stopParallaxHeight2) {
                          return true;
                        }
                        return false;
                      },
                      child: Container(
                        color: TColor.white,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: media.height * 0.02),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: media.width * 0.05),
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child: Image.network(
                                              userProfile.image,
                                              width: media.width * 0.12,
                                              height: media.width * 0.12,
                                              fit: BoxFit.cover, errorBuilder:
                                                  (context, error, stackTrace) {
                                            // Widget a mostrar en caso de error al cargar la imagen
                                            return Icon(Icons.error);
                                          }),
                                        ),
                                        SizedBox(width: media.width * 0.03),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '¡HOLA ${userProfile.name.toUpperCase()}!',
                                              style: TextStyle(
                                                  color: TColor.primary,
                                                  fontSize: media.width * 0.04,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              "Que tenga un excelente dia!",
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: media.width * 0.05),
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        hintText: "Productos, Categorías...",
                                        prefixIcon: Icon(Icons.search,
                                            color: TColor.primary),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor:
                                            TColor.secondary.withOpacity(0.4),
                                      ),
                                      onSubmitted: (value) {
                                        if (value.trim().isNotEmpty) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ProductView(
                                                  searchQuery: value.trim()),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: media.height * 0.03),
                                  _descuentos.isEmpty
                                      ? const Center(
                                          child: SizedBox(height: 3))
                                      : SizedBox(
                                          height: media.height * 0.17,
                                          child: PageView.builder(
                                            itemCount: _descuentos.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PromocionesView(),
                                                    ),
                                                  );
                                                },
                                                child: ClipRRect(
                                                  child: Image.network(
                                                    _descuentos[index].image,
                                                    width: media.width * 0.9,
                                                    height: media.height * 0.17,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                  SizedBox(height: media.height * 0.01),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: media.width * 0.05),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Categorías",
                                        style: TextStyle(
                                          color: TColor.primaryText,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: media.height * 0.01),
                                  SizedBox(
                                    height: media.height * 0.13,
                                    child: _categories.isEmpty
                                        ? const Center(
                                            child: CircularProgressIndicator())
                                        : ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: media.width * 0.03),
                                            itemCount: _categories.length,
                                            itemBuilder: ((context, index) {
                                              final category =
                                                  _categories[index];
                                              return CategoryCell(
                                                cObj: {
                                                  'image':
                                                      category.categoryImage,
                                                  'name': category.categoryName,
                                                  'id': category.categoryID,
                                                },
                                                onTap: () {},
                                                isCombo: false,
                                              );
                                            }),
                                          ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: media.width * 0.05),
                                    child: ViewAllTitleRow(
                                      title: "Oferta de Combos",
                                      onView: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ComboView()));
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: media.height * 0.22,
                                    child: _combo.isEmpty
                                        ? const Center(
                                            child: CircularProgressIndicator())
                                        : PageView.builder(
                                            itemCount: _combo.length,
                                            itemBuilder: (context, index) {
                                              final combo = _combo[index];
                                              return FutureBuilder<double>(
                                                future: _descuentoUsecase
                                                    .getDiscountedPriceCombo(
                                                        combo),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text(
                                                        'Error: ${snapshot.error}');
                                                  } else {
                                                    final discountedPrice =
                                                        snapshot.data!;
                                                    return ComboCard(
                                                      combo: combo,
                                                      onAdd: () => _cartUsecase.onAddCart(
                                                          CartItem(
                                                              id_product: combo
                                                                  .id_product,
                                                              imageUrl: combo
                                                                  .images[0],
                                                              name: combo.name,
                                                              price:
                                                                  discountedPrice,
                                                              description: combo
                                                                  .description,
                                                              peso: combo.peso,
                                                              productId: combo
                                                                  .productId,
                                                              isCombo: true,
                                                              discount: combo
                                                                  .discount,
                                                              category: combo
                                                                  .category),
                                                          context),
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: media.width * 0.05),
                                    child: ViewAllTitleRow(
                                      title: "Productos Populares",
                                      onView: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductView()));
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: media.height * 0.19,
                                    child: _product.isEmpty
                                        ? const Center(
                                            child: CircularProgressIndicator())
                                        : PageView.builder(
                                            itemCount: _product.length,
                                            itemBuilder: (context, index) {
                                              final product = _product[index];
                                              return FutureBuilder<double>(
                                                future: _descuentoUsecase
                                                    .getDiscountedPriceProduct(
                                                        product),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text(
                                                        'Error: ${snapshot.error}');
                                                  } else {
                                                    final discountedPrice =
                                                        snapshot.data!;
                                                    return ProductCard2(
                                                      product: product,
                                                      onAdd: () => _cartUsecase.onAddCart(
                                                          CartItem(
                                                              id_product: product
                                                                  .id_product,
                                                              imageUrl: product
                                                                  .images[0],
                                                              name:
                                                                  product.name,
                                                              price:
                                                                  discountedPrice,
                                                              description: product
                                                                  .description,
                                                              peso:
                                                                  product.peso,
                                                              isCombo: false,
                                                              category: product
                                                                  .category,
                                                              discount: product
                                                                  .discount),
                                                          context),
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: media.width * 0.05,
                      vertical: media.height * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isDrawerOpen
                          ? IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.yellow,
                              ),
                              onPressed: () {
                                setState(() {
                                  xOffset = 0;
                                  yOffset = 0;
                                  isDrawerOpen = false;
                                });
                              },
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.yellow,
                              ),
                              onPressed: () {
                                setState(() {
                                  xOffset = 250;
                                  yOffset = 70;
                                  isDrawerOpen = true;
                                  
                                });
                              },
                            ),
                       IconButton(
                              icon: const Icon(
                                Icons.notifications,
                                color: Colors.yellow,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationsView()));
                              },
                            ),
                      
                    ],
                  ),
                ),
              ]),
            ),
          ))
    ]);
  }

  Widget _buildDrawer() {
    return Container(
      width: 600,
      decoration: BoxDecoration(
        gradient: TColor.gradient,
      ),
      child: Column(
        children: [
          const SizedBox(height: 200),
          ListTile(
            title: const Text('      Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
          ),
          const SizedBox(height: 50),
          ListTile(
            leading: const Icon(Icons.discount, color: Colors.white),
            title: const Text('Promociones',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PromocionesView()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.card_membership, color: Colors.white),
            title: const Text('Cupones',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CuponView()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.production_quantity_limits_sharp,
                color: Colors.white),
            title: const Text('Combos',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ComboView()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat,
                color: Colors.white),
            title: const Text('GoDely ChatBot',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
          const SizedBox(height: 150),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text('Cerrar Sesión',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            onTap: () {
              showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
