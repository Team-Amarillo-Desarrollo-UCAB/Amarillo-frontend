import 'dart:math';

import 'package:flutter/material.dart';

class ProfitData {
  final String name;
  final double value;
  final Color color;

  ProfitData({
    required this.name,
    required this.value,
    required this.color,
  });


//   List<ProfitData> generateProfitDataWithColors(List<ProfitData> originalData) {
//   final random = Random();
//   return originalData.map((data) {
//     return ProfitData(
//       name: data.name,
//       value: data.value,
//       color: Color.fromARGB(
//         255,
//         random.nextInt(256), // Valor aleatorio para el canal rojo
//         random.nextInt(256), // Valor aleatorio para el canal verde
//         random.nextInt(256), // Valor aleatorio para el canal azul
//       ),
//     );
//   }).toList();
// }
}