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
    String endpoint;
    if (baseUrl == 'https://amarillo-backend-production.up.railway.app' ||
        baseUrl ==
            'https://orangeteam-deliverybackend-production.up.railway.app') {
      endpoint = '$baseUrl/product/many?name=$productName';
    } else if (baseUrl == 'https://godelybackgreen.up.railway.app/api') {
      endpoint = '$baseUrl/product/one/$productName';
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
      print('Response: ${response.statusCode}');
      final List<dynamic> data = json.decode(response.body);
      final productData = ProductData.fromJson(data[0]);
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
        image3d: productData.image3d,
      );
    } else {
      throw Exception('Error al obtener el producto');
    }
  }
}
