import 'package:flutter/material.dart';

import '../color_extension.dart';

enum RoundButtonType { bgPrimary, textPrimary }


class RoundButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final RoundButtonType type;
  final double fontSize;
  const RoundButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.fontSize = 16,
      this.type = RoundButtonType.bgPrimary});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: type == RoundButtonType.bgPrimary ? null : Border.all(color: TColor.primary, width: 1),
          gradient: type == RoundButtonType.bgPrimary ? TColor.gradient : TColor.gradientWhite,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Text(
          title,
          style: TextStyle(
              color: type == RoundButtonType.bgPrimary ? TColor.white :  TColor.primary, fontSize: fontSize, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
