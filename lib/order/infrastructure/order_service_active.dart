import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../common/infrastructure/tokenUser.dart';
import '../domain/order.dart';
import '../domain/orderData.dart';

class OrderServiceActive {
  final String baseUrl;

  OrderServiceActive(this.baseUrl);

  Future<List<Order>> getOrdersActive(int page) async {
  final token = await TokenUser().getToken();
  final response = await http.get(
    Uri.parse('$baseUrl/order/many/active?page=$page'),
    headers: {
            'Authorization': 'Bearer $token',
          }
    );
  print("Código de respuesta: ${response.statusCode}"); // Debug

  if (response.statusCode == 200) {
    final Map<String, dynamic> decodedData = json.decode(response.body);

    final orderList = decodedData.values.toList();

    return orderList.map((json) {
      final orderData = OrderData.fromJson(json);
      return Order(
        orderId: orderData.id,
        items: orderData.products,
        bundles: orderData.bundles,
        latitude: orderData.latitude,
        longitude: orderData.longitude,
        directionName: orderData.directionName,
        status: orderData.orderState,
        orderReport: orderData.orderReport,
        totalAmount: orderData.totalAmount,
        subTotal: orderData.subTotal,
        deliveryFee: orderData.shippingFee,
        discount: orderData.orderDiscount,
        currency: orderData.currency,
        paymentMethod: orderData.orderPayment['paymentMethod'],
        creationDate: orderData.orderCreatedDate.toString(),
      );
    }).toList();
  } else {
    throw Exception('Error al obtener las órdenes');
  }
}

Future<List<OrderData>> getAllOrders() async {
  List<OrderData> allOrders = [];
  int page = 1;
  bool hasMore = true;

  while (hasMore) {
    final response = await http.get(Uri.parse('$baseUrl/order/many?page=$page'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = json.decode(response.body);

      if (decodedData.isEmpty) {
        hasMore = false;
      } else {
        allOrders.addAll(
          decodedData.values.map<OrderData>((jsonOrder) => OrderData.fromJson(jsonOrder)).toList(),
        );
        page++;
      }
    } else {
      throw Exception('Error al obtener las órdenes en la página $page');
    }
  }
  return allOrders;
}
}