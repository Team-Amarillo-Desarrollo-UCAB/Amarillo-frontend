
import 'package:flutter/material.dart';

import '../infrastructure/base_url.dart';


class TColor {
  static Color get primary {
    if (BaseUrl().BASE_URL == BaseUrl().ORANGE) {
      return const Color.fromARGB(255, 255, 10, 10);
    } else if (BaseUrl().BASE_URL == BaseUrl().VERDE) {
      return const Color.fromARGB(255, 5, 150, 53);
    }
    return const Color(0xffFC6011); 
  }
  static Color get secondary {
    if (BaseUrl().BASE_URL == BaseUrl().ORANGE) {
      return const Color.fromARGB(255, 255, 142, 55);
    } else if (BaseUrl().BASE_URL == BaseUrl().VERDE) {
      return const Color.fromARGB(255, 59, 250, 123);
    }
    return const Color.fromARGB(255, 252, 201, 17); 
  }
  static Color get primaryText => const Color(0xff4A4B4D);
  static Color get secondaryText => const Color(0xff7C7D7E);
  static Color get textfield => const Color.fromARGB(255, 225, 225, 225);
  static Color get placeholder => const Color(0xffB6B7B7);
  static Color get white => const Color(0xffffffff);
  static Color get black => const Color.fromARGB(255, 0, 0, 0);
  static LinearGradient get gradient {
    if (BaseUrl().BASE_URL == BaseUrl().ORANGE) {
      return const LinearGradient(colors:[Color.fromARGB(255, 255, 142, 55), Color.fromARGB(255, 255, 10, 10)]);
    } else if (BaseUrl().BASE_URL == BaseUrl().VERDE) {
      return const LinearGradient(colors:[Color.fromARGB(255, 5, 150, 53), Color.fromARGB(255, 59, 250, 123)]);
    }
    return const LinearGradient(colors:[Color(0xffFC6011), Color.fromARGB(255, 252, 201, 17)]); 
  }
  static LinearGradient get gradientWhite => const LinearGradient(colors:[Color(0xffffffff), Color(0xffffffff)],);
}