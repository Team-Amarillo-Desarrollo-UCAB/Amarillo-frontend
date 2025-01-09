import 'dart:convert';
import 'package:desarrollo_frontend/categorias/domain/category.dart';
import 'package:desarrollo_frontend/categorias/domain/category_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/infrastructure/tokenUser.dart';

class CategoryService {
  final String baseUrl;

  CategoryService(this.baseUrl);

  Future<List<Category>> getCategories() async {
    final token = await TokenUser().getToken();
    final response =
        await http.get(Uri.parse('$baseUrl/category/many'), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) {
        final categoryData =
            CategoryData.fromJson(json as Map<String, dynamic>);
        return Category(
          categoryID: categoryData.id,
          categoryImage: NetworkImage(categoryData.image),
          categoryName: categoryData.name,
        );
      }).toList();
    } else {
      throw Exception('Error al obtener la lista de categorías');
    }
  }
}
