import 'package:http/http.dart' as http;
import 'dart:convert';

import '../presentation/order_history.dart';

class OrderService {
  final String baseUrl;

  OrderService(this.baseUrl);

  Future<List<Order>> getOrders(int page) async {
  final response = await http.get(Uri.parse('$baseUrl/order/many?page=$page'));
  print("Código de respuesta: ${response.statusCode}"); // Debug

  if (response.statusCode == 200) {
    final Map<String, dynamic> decodedData = json.decode(response.body);
    return decodedData.values
            .map<Order>((jsonOrder) => Order.fromJson(jsonOrder))
            .toList();
  } else {
    throw Exception('Error al obtener las órdenes');
  }
}

Future<List<Order>> getAllOrders() async {
  List<Order> allOrders = [];
  int page = 1;
  bool hasMore = true;

  while (hasMore) {
    final response = await http.get(Uri.parse('$baseUrl/order/many?page=$page'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = json.decode(response.body);

      if (decodedData.isEmpty) {
        hasMore = false; // Si no hay más datos, termina el ciclo
      } else {
        allOrders.addAll(
          decodedData.values.map<Order>((jsonOrder) => Order.fromJson(jsonOrder)).toList(),
        );
        page++;
      }
    } else {
      throw Exception('Error al obtener las órdenes en la página $page');
    }
  }
  return allOrders;
}



  /// Obtiene una orden específica por ID
  Future<Order> getOrderById(String orderId) async {
    print("OrderID" + orderId);
    final response =
        await http.get(Uri.parse('$baseUrl/order/one/by/$orderId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return Order.fromJson(data);
    } else {
      throw Exception('Error al obtener la orden con ID $orderId');
    }
  }
}