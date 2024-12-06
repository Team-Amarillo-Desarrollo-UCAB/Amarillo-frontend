import 'dart:convert';
import 'package:desarrollo_frontend/Descuento/Domain/Descuento.dart';
import 'package:desarrollo_frontend/Descuento/Domain/descuento_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DescuentoServiceSearchById {
  final String baseUrl;

  DescuentoServiceSearchById(this.baseUrl);

  Future<Descuento> getDescuentoById(String descuentoId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/discount/one/$descuentoId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Aquí directamente accedemos al objeto del producto
      final descuentoData = DescuentoData.fromJson(data);

      return Descuento(
        id: descuentoId,
        name: descuentoData.name,
        percentage: descuentoData.percentage,
        description: descuentoData.description,
      );
    } else {
      throw Exception('Error al obtener el descuento');
    }
  }
}
