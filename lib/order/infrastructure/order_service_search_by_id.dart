import 'package:desarrollo_frontend/order/domain/orderData.dart';

import '../../common/infrastructure/tokenUser.dart';
import '../domain/order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderServiceSearchById {
  final String baseUrl;

  OrderServiceSearchById(this.baseUrl);

  Future<Order> getOrderById(String orderId) async {
    print("OrderID" + orderId);
    final token = await TokenUser().getToken();
    final response =
        await http.get(
          Uri.parse('$baseUrl/order/one/by/$orderId'),
          headers: {
            'Authorization': 'Bearer $token',
          }
          );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final orderData = OrderData.fromJson(data);

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
    }else {
      throw Exception('Error al obtener la orden');
  }
  }
}