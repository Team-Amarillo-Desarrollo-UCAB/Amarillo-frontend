import 'package:desarrollo_frontend/categorias/presentation/categorias_combo_view.dart';
import 'package:desarrollo_frontend/categorias/presentation/categorias_product_view.dart';
import 'package:flutter/material.dart';
import 'package:desarrollo_frontend/common/presentation/color_extension.dart';

class CategoryCell extends StatelessWidget {
  final Map cObj;
  final VoidCallback onTap;
  final bool isCombo;

  const CategoryCell(
      {super.key,
      required this.cObj,
      required this.onTap,
      required this.isCombo});
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: media.width * 0.02),
      child: InkWell(
        onTap: () {
          if (isCombo) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoriasComboView(
                  idCategory: cObj["id"],
                  idName: cObj["name"],
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoriasProductView(
                  idCategory: cObj["id"],
                  idName: cObj["name"],
                ),
              ),
            );
          }
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(media.width * 0.2),
              child: Image(
                image: cObj["image"] as ImageProvider<Object>,
                width: media.width * 0.15,
                height: media.width * 0.15,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: media.height * 0.01,
            ),
            Text(
              cObj["name"],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: media.width * 0.035,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
