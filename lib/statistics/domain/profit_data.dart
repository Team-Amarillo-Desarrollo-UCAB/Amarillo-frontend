import 'dart:math';
import 'package:flutter/material.dart';

class ProfitData {
  final String name;
  final double value;
  final Color color;

  // Constructor principal
  ProfitData({
    required this.name,
    required this.value,
    Color? color, // Permite asignar color manualmente o generarlo automáticamente
  }) : color = color ?? ProfitData.generateRandomColor();

  // Método estático para generar un color dinámico
  static Color generateRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
