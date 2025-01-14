import 'package:flutter/material.dart';

import '../domain/profit_data.dart';

class GetProfitUseCase {
  List<ProfitData> execute() {
    // Aquí podrías recuperar datos desde un repositorio o servicio.
    return [
      ProfitData(name: 'Rosa', value: 169, color: const Color(0xFFFFC1E3)),
      ProfitData(name: 'Lavanda', value: 143, color: const Color(0xFFCE93D8)),
      // Agregar más datos...
    ];
  }
}
