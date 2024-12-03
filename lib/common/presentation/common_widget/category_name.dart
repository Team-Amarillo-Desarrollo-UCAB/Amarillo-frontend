import 'package:flutter/material.dart';

import '../color_extension.dart';
import 'round_button.dart';

class CategoryName extends StatelessWidget {
  final Map cObj;
  final VoidCallback onTap;
  final RoundButtonType type;
  final VoidCallback onPressed;
  const CategoryName({super.key, required this.cObj, required this.onTap, required this.onPressed,this.type = RoundButtonType.bgPrimary});


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 15,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: type == RoundButtonType.bgPrimary ? null : Border.all(color: TColor.primary, width: 1),
          gradient: type == RoundButtonType.bgPrimary ? TColor.gradient : TColor.gradientWhite,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Text(
          cObj["name"],
          style: TextStyle(
              color: type == RoundButtonType.bgPrimary ? TColor.white :  TColor.primary, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
