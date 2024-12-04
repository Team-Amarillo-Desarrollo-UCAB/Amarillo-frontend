import 'package:flutter/material.dart';

import '../color_extension.dart';


class TitleOnly extends StatelessWidget {
  final String title;
  final VoidCallback onView;
  const TitleOnly({super.key, required this.title, required this.onView });

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
                const SizedBox(
          width: 90,
        ),
      ],
    );
  }
}