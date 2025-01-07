import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../common/infrastructure/tokenUser.dart';
import '../domain/product_data.dart';
import '../domain/product.dart';

class ProductServiceSearch {
  final String baseUrl;

  ProductServiceSearch(this.baseUrl);

  Future<Product> getProductByName(String productName) async {
    final token = await TokenUser().getToken();

    final response = await http.get(
        Uri.parse('$baseUrl/product/one/by/name?name=$productName'),
        headers: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final productData = ProductData.fromJson(data);

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
    } else {
      throw Exception('Error al obtener el producto');
    }
  }
}
