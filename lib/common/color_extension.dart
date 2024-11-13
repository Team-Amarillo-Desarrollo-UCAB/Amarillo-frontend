
import 'package:flutter/material.dart';

class TColor {
  static Color get primary => const Color(0xffFC6011);
  static Color get secondary => const Color.fromARGB(255, 252, 201, 17);
  static Color get primaryText => const Color(0xff4A4B4D);
  static Color get secondaryText => const Color(0xff7C7D7E);
  static Color get textfield => const Color.fromARGB(255, 225, 225, 225);
  static Color get placeholder => const Color(0xffB6B7B7);
  static Color get white => const Color(0xffffffff);
  static LinearGradient get gradient => const LinearGradient(colors:[Color(0xffFC6011), Color.fromARGB(255, 252, 201, 17)],);
  static LinearGradient get gradientWhite => const LinearGradient(colors:[Color(0xffffffff), Color(0xffffffff)],);
}