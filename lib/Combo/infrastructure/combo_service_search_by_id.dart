import 'dart:convert';
import 'package:desarrollo_frontend/Combo/domain/combo.dart';
import 'package:desarrollo_frontend/Combo/domain/combo_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/infrastructure/tokenUser.dart';

class ComboServiceSearchById {
  final String baseUrl;

  ComboServiceSearchById(this.baseUrl);

  Future<Combo> getComboById(String comboId) async {
    final token = await TokenUser().getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/bundle/one/$comboId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final comboData = ComboData.fromJson(data);
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
    } else {
      throw Exception('Error al obtener el combo');
    }
  }
}
