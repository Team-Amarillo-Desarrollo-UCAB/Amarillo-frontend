import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../application/product_data.dart';
import '../domain/home/popular_product.dart';

class ProductService {
  final String baseUrl;

  ProductService(this.baseUrl);

  Future<List<Product>> getProducts(int page) async {
    final response =
        await http.get(Uri.parse('$baseUrl/product/many?page=$page'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);


      final productsList = data.values.toList();


      return productsList.map((json) {
        final productData = ProductData.fromJson(json);
        return Product(
            id_product: productData.id_product,
            image: NetworkImage(productData
                .imageUrl), 
            name: productData.name,
            price: productData.price,
            description: productData.description,
            peso: '${productData.quantity} ${productData.unitMeasure}');
      }).toList();
    } else {
      throw Exception('Error al obtener la lista de productos');
    }
  }
}
