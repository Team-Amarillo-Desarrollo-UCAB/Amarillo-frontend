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
    //Future<List<Descuento>> getDescuento() async {
    final response = await http
        .get(Uri.parse('$baseUrl/discount/many?page=$page'), headers: {
      'Authorization': 'Bearer $token',
    });
    //await http.get(Uri.parse('$baseUrl/discount/many'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final discountsList = data.values.toList();
      return discountsList.map((json) {
        final descuentoData = DescuentoData.fromJson(json);

        return Descuento(
            id: descuentoData.id,
            name: descuentoData.name,
            percentage: descuentoData.percentage,
            description: descuentoData.description,
            image: descuentoData.image);
      }).toList();
    } else {
      throw Exception('Error al obtener la lista de descuentos');
    }
  }
}
