import 'dart:convert';
import 'package:desarrollo_frontend/Combo/domain/combo.dart';
import 'package:desarrollo_frontend/Combo/domain/combo_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/infrastructure/base_url.dart';
import '../../common/infrastructure/tokenUser.dart';

class ComboPopularService {
  final String baseUrl;

  ComboPopularService(this.baseUrl);

  Future<List<Combo>> getCombo() async {
    final token = await TokenUser().getToken();
    String endpoint;
    if (baseUrl == 'https://amarillo-backend-production.up.railway.app') {
      endpoint = '$baseUrl/bundle/many?popular=si';
    } else if (baseUrl == 'https://godelybackgreen.up.railway.app/api' ||
        baseUrl ==
            'https://orangeteam-deliverybackend-production.up.railway.app') {
      endpoint = '$baseUrl/bundle/many?page=1&perpage=3';
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
        final comboData = ComboData.fromJson(json);
        return Combo(
            id_product: comboData.id,
            images: comboData.images
                .map((imageUrl) => NetworkImage(imageUrl))
                .toList(),
            productId: comboData.productId,
            name: comboData.name,
            price: comboData.price,
            description: comboData.description,
            peso: '${comboData.weight} ${comboData.measurement}',
            discount: comboData.discount,
            category: comboData.category);
      }).toList();
    } else {
      throw Exception('Error al obtener la lista de productos');
    }
  }
}
