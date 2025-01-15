import 'package:desarrollo_frontend/order/domain/orderDataOrange.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../common/infrastructure/tokenUser.dart';
import '../domain/order.dart';
import '../domain/orderData.dart';

class OrderService {
  final String baseUrl;

  OrderService(this.baseUrl);

  Future<List<Order>> getOrders(int page, List<String> status) async {
  final token = await TokenUser().getToken();
    if(baseUrl == 'https://amarillo-backend-production.up.railway.app') {
        String url = '$baseUrl/order/many?page=$page';
    
  for (var s in status) {
    url += '&status=$s';
  }
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      }
    );
  print("Código de respuesta: ${response.statusCode}"); // Debug

  if (response.statusCode == 200) {
    final Map<String, dynamic> decodedData = json.decode(response.body);

    final List<dynamic> orders = decodedData['orders'];

    return orders.map((json) {
      final orderData = OrderData.fromJson(json);
      return Order(
        orderId: orderData.id,
        items: orderData.products,
        bundles: orderData.bundles,
        latitude: orderData.latitude,
        longitude: orderData.longitude,
        directionName: orderData.directionName,
        status: orderData.orderState,
        totalAmount: orderData.totalAmount,
        orderReport: orderData.orderReport,
        subTotal: orderData.subTotal,
        deliveryFee: orderData.shippingFee,
        discount: orderData.orderDiscount,
        currency: orderData.currency,
        paymentMethod: orderData.orderPayment['paymentMethod'],
        creationDate: orderData.orderCreatedDate.toString(),
      );
    }).toList();
  } else {
    throw Exception('Error al obtener las órdenes con backend amarillo');
  }
}else if (baseUrl == 'https://orangeteam-deliverybackend-production.up.railway.app') {
    String createdOrCancelledStatus = status.firstWhere( (s) => s == "CREATED" || s == "CANCELLED", orElse: () => "No Status Found", );
    String url = '$baseUrl/order/many?status=$createdOrCancelledStatus';
    
    
  /*for (var s in status) {
    url += '&status=$s';
  }*/
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      }
    );
  print("Código de respuesta: ${response.statusCode}"); // Debug

  if (response.statusCode == 200) {
    final List<dynamic> decodedData = json.decode(response.body);

    return decodedData.map((json) {
      final orderData = OrderDataOrange.fromJson(json);
      return Order(
        orderId: orderData.id,
        items: orderData.products,
        bundles: orderData.combos,
        latitude: orderData.latitude,
        longitude: orderData.longitude,
        directionName: orderData.address,
        status: orderData.status,
        totalAmount: orderData.paymentMethod['total'].toString(),
        orderReport: orderData.report['description'],
        subTotal: '0',
        deliveryFee: '0',
        discount: '0',
        currency: orderData.paymentMethod['currency'],
        paymentMethod: orderData.paymentMethod['paymentMethod'],
        creationDate: orderData.createdDate.toString(),
      );
    }).toList();
}else{
    throw Exception('Error al obtener las órdenes');
}
}else{
      throw Exception('Error al obtener las órdenes con algun backend');
    }
}
}
