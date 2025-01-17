import 'dart:convert';
import 'package:desarrollo_frontend/Cupon/domain/Cupon.dart';
import 'package:desarrollo_frontend/Cupon/domain/Cupon_data.dart';
import 'package:desarrollo_frontend/common/infrastructure/tokenUser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CuponServiceSearchByCode {
  final String baseUrl;

  CuponServiceSearchByCode(this.baseUrl);

  Future<Cupon> getCuponByCode(String cuponCode) async {
    final token = await TokenUser().getToken();
    if (baseUrl == 'https://amarillo-backend-production.up.railway.app') {
      final response = await http.get(
          Uri.parse('$baseUrl/cupon/one/by/code?code=$cuponCode'),
          headers: {
            'Authorization': 'Bearer $token',
          });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final cuponData = CuponData.fromJson(data);

        return Cupon(
            code: cuponData.code,
            expirationDate: DateTime.parse(cuponData.expirationDate),
            amount: cuponData.amount,
            used: cuponData.used,
            use: cuponData.use);
      } else {
        throw Exception('Error al obtener el cupon');
      }
    } else if (baseUrl ==
            'https://orangeteam-deliverybackend-production.up.railway.app' ||
        baseUrl == 'https://godelybackgreen.up.railway.app/api') {
      final response = await http
          .get(Uri.parse('$baseUrl/cupon/one/by/$cuponCode'), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final cuponData = CuponData.fromJson(data);

        return Cupon(
            code: cuponData.code,
            expirationDate: DateTime.parse(cuponData.expirationDate),
            amount: cuponData.amount,
            used: cuponData.used,
            use: cuponData.use);
      } else {
        throw Exception('Error al obtener el cupon');
      }
    } else {
      throw Exception('Base URL no reconocida');
    }
  }
}
