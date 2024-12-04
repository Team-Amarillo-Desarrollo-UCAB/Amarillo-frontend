import 'package:desarrollo_frontend/Combo/presentation/combo_view.dart';
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
  TextEditingController txtSearch = TextEditingController();
  List<Product> _product = [];
  final CartService _cartService = CartService();
  final ProductService _productService = ProductService(BaseUrl().BASE_URL);

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Llamar al método de carga de productos cuando se inicia el widget
  }

  Future<void> _fetchProducts() async {
    try {
      List<Product> products = await _productService.getProducts(1);
      setState(() {
        _product = products;
      });
    } catch (error) {
      print('Error al obtener productos: $error');
    }
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

  List catArr = [
    {"image": "assets/img/comida.png", "name": "Comida"},
    {"image": "assets/img/Infantil.png", "name": "Infantil"},
    {"image": "assets/img/Belleza.png", "name": "Belleza"},
    {"image": "assets/img/Salud.png", "name": "Salud"},
    {"image": "assets/img/Hogar.png", "name": "Hogar"},
  ];

  List mostPopArr = [
    {
      "image": "assets/img/almuerzo_familiar.png",
      "name": "Almuerzo Familiar",
      "price": "30",
    },
    {
      "image": "assets/img/cesta_basica.png",
      "name": "Cesta Basica",
      "price": "102,90",
    },
  ];

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
                child: RoundTextfield(
                  hintText: "Productos, Categorías...",
                  controller: txtSearch,
                  left: Container(
                    alignment: Alignment.center,
                    width: media.width * 0.08,
                    child: Image.asset(
                      "assets/img/search.png",
                      width: media.width * 0.05,
                      color: TColor.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: media.height * 0.03),
              ClipRRect(
                borderRadius: BorderRadius.circular(media.width * 0.03),
                child: Image.asset(
                  'assets/img/oferta.png',
                  width: media.width * 0.9,
                  height: media.height * 0.17,
                  fit: BoxFit.cover,
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
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: media.width * 0.03),
                  itemCount: catArr.length,
                  itemBuilder: ((context, index) {
                    var cObj = catArr[index] as Map? ?? {};
                    return CategoryCell(
                      cObj: cObj,
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
                height: media.height * 0.23,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: media.width * 0.03),
                  itemCount: mostPopArr.length,
                  itemBuilder: ((context, index) {
                    var mObj = mostPopArr[index] as Map? ?? {};
                    return MostPopularCell(
                      mObj: mObj,
                      onTap: () {},
                    );
                  }),
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
                height: media.height * 0.25,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: media.width * 0.03),
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
