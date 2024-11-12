
import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
import '../../common_widget/category_cell.dart';
import '../../common_widget/most_popular_cell.dart';
import '../../common_widget/round_textfield.dart';
import '../../common_widget/view_all_title_row.dart';
import '../Carrito/cart_item.dart';
import 'popular_product.dart';
import 'popular_product_widget.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController txtSearch = TextEditingController();
  List<CartItem> globalCartItems = [];



  void onAdd(Product product) {
  }

  // Actualizar el estado si es necesari


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
   final List _product = [
    Product(
      image: const NetworkImage('https://web.superboom.net/web/image/product.product/34120/image_128'),
      name: 'Harina Pan',
      price: 10.5,
      description: '1 kg',
    ),
    Product(
      image: const NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgUqCgTNTnh9nIX_FnzrDfssfSaGMb9PVeMQ&s'),
      name: 'Nestle - Limón',
      price: 1.5,
      description: '120 gr',
    ),
    Product(
      image: const NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgUqCgTNTnh9nIX_FnzrDfssfSaGMb9PVeMQ&s'),
      name: 'Nestle - Durazno',
      price: 1.5,
      description: '120 gr',
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipOval(
                              child: Image.asset(
                                'assets/img/perfil.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover, 
                              ),
                            ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(
                          // "Good morning ${ServiceCall.userPayload[KKey.name] ?? ""}!",
                          "¡HOLA CARLOS!",
                          style: TextStyle(
                              color: TColor.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Sábana Grande, Caracas",
                          style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ],
                ),
                  ],
            ),
          ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RoundTextfield(
                  hintText: "Productos, Categorías...",
                  controller: txtSearch,
                  left: Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: Image.asset(
                      "assets/img/search.png",
                      width: 20,
                      height: 20,
                      color: TColor.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                child: Image.asset(
                  'assets/img/oferta.png',
                  width: 400,
                height: 180,
                fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ViewAllTitleRow(
                  title: "Categorías",
                  onView: () {},
                ),
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ViewAllTitleRow(
                  title: "Oferta de Combos",
                  onView: () {},
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ViewAllTitleRow(
                  title: "Productos Populares",
                  onView: () {},
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: _product.length,
                  itemBuilder: (context, index) {
                    final product = _product[index];
                    return ProductCard(
                      product: product,
                      onAdd: () => onAdd(product), // Llamada a la función onAdd
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
