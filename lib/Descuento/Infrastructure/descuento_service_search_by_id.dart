import 'dart:convert';
import 'package:desarrollo_frontend/descuento/domain/descuento.dart';
import 'package:desarrollo_frontend/descuento/domain/descuento_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/infrastructure/tokenUser.dart';

class DescuentoServiceSearchById {
  final String baseUrl;

  DescuentoServiceSearchById(this.baseUrl);

  Future<Descuento> getDescuentoById(String descuentoId) async {
    final token = await TokenUser().getToken();

    final response = await http
        .get(Uri.parse('$baseUrl/discount/one/$descuentoId'), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final descuentoData = DescuentoData.fromJson(data);
      return Descuento(
        id: descuentoId,
        name: descuentoData.name,
        percentage: descuentoData.percentage,
        description: descuentoData.description,
        image: descuentoData.image,
        fechaExp: DateTime.parse(descuentoData.fechaExp),
      );
    } else {
      throw Exception('Error al obtener el descuento');
    }
  }
}
