import 'package:flutter/material.dart';
import 'package:desarrollo_frontend/common/presentation/color_extension.dart';

import '../../../categorias/presentation/category_items_view.dart';

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
