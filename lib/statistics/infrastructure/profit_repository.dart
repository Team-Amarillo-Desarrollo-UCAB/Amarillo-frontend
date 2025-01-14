import 'package:flutter/material.dart';

import '../domain/profit_data.dart';

class ProfitRepository {
  Future<List<ProfitData>> fetchProfitData() async {
    // Simulación de datos recuperados de un servicio externo.
    await Future.delayed(const Duration(seconds: 1)); // Simula latencia.
    return [
      ProfitData(name: 'Rosa', value: 169, color: const Color(0xFFFFC1E3)),
      ProfitData(name: 'Lavanda', value: 143, color: const Color(0xFFCE93D8)),
    ];
  }
}
