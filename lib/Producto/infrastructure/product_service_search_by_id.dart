import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../common/infrastructure/tokenUser.dart';
import '../domain/product_data.dart';
import '../domain/popular_product.dart';

class ProductServiceSearchbyId {
  final String baseUrl;

  ProductServiceSearchbyId(this.baseUrl);

  Future<Product> getProductById(String productId) async {

    final token = await TokenUser().getToken();

    final response =
        await http.get(
          Uri.parse('$baseUrl/product/one/$productId'),
          headers:{
            'Authorization': 'Bearer $token',
          }
          );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      
      final productData = ProductData.fromJson(data);

      return Product(
        id_product: productId,
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
