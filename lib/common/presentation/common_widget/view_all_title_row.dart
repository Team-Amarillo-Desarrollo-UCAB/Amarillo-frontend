import 'package:flutter/material.dart';

import '../color_extension.dart';

class ViewAllTitleRow extends StatelessWidget {
  final String title;
  final VoidCallback onView;
  const ViewAllTitleRow({super.key, required this.title, required this.onView });


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w800),
        ),
        Row(
          children: [
            TextButton(
              onPressed: onView,
              child: Text(
                "Ver más",
                style: TextStyle(
                    color: TColor.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Image.asset(
              "assets/img/dropdown.png",
              width: 12,
              height: 12,
            )
          ],
        ),
      ],
    );
  }
}