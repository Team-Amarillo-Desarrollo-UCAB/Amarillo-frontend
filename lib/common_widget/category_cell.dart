import 'package:flutter/material.dart';
import 'package:desarrollo_frontend/common/color_extension.dart';

import '../domain/categorias/category_items_view.dart';

class CategoryCell extends StatelessWidget {
  final Map cObj;
  final VoidCallback onTap;

  const CategoryCell({super.key, required this.cObj, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: media.width * 0.02),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductListView()),
          );
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(media.width * 0.2),
              child: Image.asset(
                cObj["image"].toString(),
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
