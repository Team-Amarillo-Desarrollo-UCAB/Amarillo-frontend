import 'dart:convert';
import 'package:desarrollo_frontend/descuento/domain/descuento.dart';
import 'package:desarrollo_frontend/descuento/domain/descuento_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/infrastructure/tokenUser.dart';

class DescuentoService {
  final String baseUrl;

  DescuentoService(this.baseUrl);

  Future<List<Descuento>> getDescuento() async {
    final token = await TokenUser().getToken();
    String endpoint;
    if (baseUrl == 'https://amarillo-backend-production.up.railway.app' ||
        baseUrl ==
            'https://orangeteam-deliverybackend-production.up.railway.app') {
      endpoint = '$baseUrl/discount/many';
    } else if (baseUrl == 'https://godelybackgreen.up.railway.app/api') {
      endpoint = '$baseUrl/discount/many?page=1&perpage=10';
    } else {
      throw Exception('Base URL no reconocida');
    }

    final response = await http.get(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

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
