import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../domain/product_data.dart';
import '../domain/product.dart';
import 'package:desarrollo_frontend/common/infrastructure/tokenUser.dart';

class ProductService {
  final String baseUrl;

  ProductService(this.baseUrl);

  Future<List<Product>> getProducts(int page) async {
    try {
      final token = await TokenUser().getToken();

      if (token == null) {
        throw Exception('No se encontró un token para el usuario.');
      }

      String endpoint;
      if (baseUrl == 'https://amarillo-backend-production.up.railway.app') {
        endpoint = '$baseUrl/product/many?page=$page';
      } else if (baseUrl == 'https://godelybackgreen.up.railway.app/api') {
        endpoint = '$baseUrl/product/many?page=1&perpage=10';
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
          final productData =
              ProductData.fromJson(json as Map<String, dynamic>);
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
