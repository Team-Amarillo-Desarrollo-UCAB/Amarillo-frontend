import 'dart:convert';
import 'package:desarrollo_frontend/Combo/domain/combo.dart';
import 'package:desarrollo_frontend/Combo/domain/combo_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/infrastructure/tokenUser.dart';

class ComboCategoryService {
  final String baseUrl;

  ComboCategoryService(this.baseUrl);

  Future<List<Combo>> getCombo(int page, List<String> categories) async {
    final token = await TokenUser().getToken();
    final categoriesParam = categories.join(',');
    final response = await http.get(
      Uri.parse('$baseUrl/bundle/many?page=$page&category=$categoriesParam'),
      headers: {
        'Authorization': 'Bearer $token',
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
