import 'dart:convert';
import 'package:desarrollo_frontend/Descuento/Domain/descuento.dart';
import 'package:desarrollo_frontend/Descuento/Domain/descuento_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/infrastructure/tokenUser.dart';

class DescuentoService {
  final String baseUrl;

  DescuentoService(this.baseUrl);

  Future<List<Descuento>> getDescuento(int page) async {
    final token = await TokenUser().getToken();
    final response = await http
        .get(Uri.parse('$baseUrl/discount/many?page=$page'), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((json) {
        final descuentoData =
            DescuentoData.fromJson(json as Map<String, dynamic>);

        return Descuento(
            id: descuentoData.id,
            name: descuentoData.name,
            percentage: descuentoData.percentage,
            description: descuentoData.description,
            image: descuentoData.image,
            fechaExp: DateTime.parse(descuentoData.fechaExp));
      }).toList();
    } else {
      throw Exception('Error al obtener la lista de descuentos');
    }
  }
}
