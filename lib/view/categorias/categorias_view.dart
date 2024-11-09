import 'package:flutter/material.dart';
import 'package:godely_front/common_widget/title_only.dart';

import '../../../common/color_extension.dart';
import '../../../common_widget/round_textfield.dart';
import '../../common_widget/category_cell.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _MenuViewState();
}

class _MenuViewState extends State<CategoryView> {
  List catArr = [
    {"image": "assets/img/comida.png", "name": "Comida"},
    {"image": "assets/img/Infantil.png", "name": "Infantil"},
    {"image": "assets/img/Belleza.png", "name": "Belleza"},
    {"image": "assets/img/Salud.png", "name": "Salud"},
    {"image": "assets/img/Hogar.png", "name": "Hogar"},
    {"image": "assets/img/Oficina.png", "name": "Oficina"},
    {"image": "assets/img/Jardin.png", "name": "Jardin"},
    {"image": "assets/img/Limpieza.png", "name": "Limpieza"},
  ];

  TextEditingController txtSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.centerLeft,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 36,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 46,
                        ),
                        Text(
                          "Categorias",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
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
                      hintText: "Productos, Categorias",
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
                    height: 30,
                  ),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                    child: Image.asset(
                      'assets/img/oferta2.png',
                      width: 400,
                      height: 180,
                    fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TitleOnly(
                  title: "Todas las categorías",
                  onView: () {},
                ),
              ),
                const SizedBox(
                  height: 30,
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
                ],
              ),
            ),
            
          ),
        ],
      ),
    );
  }
}
