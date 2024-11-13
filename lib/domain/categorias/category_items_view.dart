import 'package:flutter/material.dart';
import '../../common_widget/category_name.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';

class CategoryItemsView extends StatefulWidget {
  //final Map mObj;
  const CategoryItemsView({super.key}); //required this.mObj

  @override
  State<CategoryItemsView> createState() => _MenuItemsViewState();
}


class _MenuItemsViewState extends State<CategoryItemsView> {
  TextEditingController txtSearch = TextEditingController();

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
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset("assets/img/btn_back.png",
                          width: 20, height: 20),
                    ),
                    const SizedBox(
                      width: 100,
                    ),
                    Expanded(
                      child: Text(
                        "Productos",
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
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
                height: 15,
              ),
              SizedBox(
                height: 120,
                
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: catArr.length,
                  itemBuilder: ((context, index) {
                    var cObj = catArr[index] as Map? ?? {};
                    return CategoryName(
                      cObj: cObj,
                      onTap: () {},
                      onPressed: () {},
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
