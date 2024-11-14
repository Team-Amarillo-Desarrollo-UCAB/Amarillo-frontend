import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../application/product_data.dart';
import '../domain/home/popular_product.dart';

class ProductServiceSearch {
  final String baseUrl;

  ProductServiceSearch(this.baseUrl);

  Future<Product> getProductByName(String productName) async {
    final response = await http.get(Uri.parse('$baseUrl/product/one/by/name?name=$productName'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Aquí directamente accedemos al objeto del producto
      final productData = ProductData.fromJson(data);

      return Product(
        image: NetworkImage(productData.imageUrl), 
        name: productData.name,
        price: productData.price,
        description: productData.description,
        peso: '${productData.quantity} ${productData.unitMeasure}',
      );
    } else {
      throw Exception('Error al obtener el producto');
    }
  }
}
