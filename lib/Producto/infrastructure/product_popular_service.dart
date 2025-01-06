import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../domain/product_data.dart';
import '../domain/popular_product.dart';
import 'package:desarrollo_frontend/common/infrastructure/tokenUser.dart';

class ProductPopularService {
  final String baseUrl;

  ProductPopularService(this.baseUrl);

  Future<List<Product>> getProducts() async {
    try {
      final token = await TokenUser().getToken();

      if (token == null) {
        throw Exception('No se encontró un token para el usuario.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/product/many?popular=si'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final productsList = data.values.toList();

        return productsList.map((json) {
          final productData = ProductData.fromJson(json);
          return Product(
            id_product: productData.id_product,
            images: productData.images
                .map((imageUrl) => NetworkImage(imageUrl))
                .toList(),
            name: productData.name,
            price: productData.price,
            description: productData.description,
            peso: '${productData.quantity} ${productData.unitMeasure}',
            category: productData.category,
            discount: productData.discount,
          );
        }).toList();
      } else {
        throw Exception(
            'Error al obtener la lista de productos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener los productos: $e');
    }
  }
}
