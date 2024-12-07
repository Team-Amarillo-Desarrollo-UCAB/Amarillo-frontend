import 'dart:convert';
import 'package:desarrollo_frontend/Checkout/domain/payment_method_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PaymentMethod {
  final String idPayment;
  final String name;

  PaymentMethod({
    required this.idPayment,
    required this.name,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      idPayment: json['idPayment'],
      name: json['name'],
    );
  }
}

class PaymentService {
  final String baseUrl;

  PaymentService(this.baseUrl);

  Future<List<PaymentMethod>> getPaymentMethods(int page) async {
    final response = await http.get(Uri.parse('$baseUrl/payment/method/many?page=$page'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      
      final paymentlist = data;

      return paymentlist.where((method) => method['active'] == true).map((json) {
        final paymentData = PaymentData.fromJson(json);
        return PaymentMethod(
          idPayment: paymentData.id_payment,
          name: paymentData.name,
        );
      }).toList();
    } else {
      throw Exception('Error al obtener la lista de métodos de pago');
    }
  }
}
