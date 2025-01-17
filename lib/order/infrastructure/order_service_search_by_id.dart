import 'package:desarrollo_frontend/order/domain/orderData.dart';
import 'package:desarrollo_frontend/order/domain/orderDataGreen.dart';
import 'package:desarrollo_frontend/order/domain/orderDataOrange.dart';

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
    if(baseUrl == 'https://amarillo-backend-production.up.railway.app') {
        final response =
            await http.get(
              Uri.parse('$baseUrl/order/one/$orderId'),
              headers: {
                'Authorization': 'Bearer $token',
              }
              );// Debug
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
          throw Exception('Error al obtener la orden con backend amarillo');
      }
    }else if( baseUrl == 'https://orangeteam-deliverybackend-production.up.railway.app') {
      final response =
          await http.get(
            Uri.parse('$baseUrl/order/one/$orderId'),
            headers: {
              'Authorization': 'Bearer $token',
            });
      print("Código de respuesta: ${response.statusCode}"); // Debug
      print("la url es: $baseUrl");
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

          final orderData = OrderDataOrange.fromJson(data);

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
      }else {
        throw Exception('Error al obtener la orden con backend naranja');
      }
    }else if(baseUrl == 'https://godelybackgreen.up.railway.app/api') {
      final response =
          await http.get(
            Uri.parse('$baseUrl/order/one/$orderId'),
            headers: {
              'Authorization': 'Bearer $token',
            });
      print("Código de respuesta: ${response.statusCode}"); // Debug
      print("la url es: $baseUrl");
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final orderData = OrderDataGreen.fromJson(data);

        return Order(
        orderId: orderData.id,
        items: orderData.products,
        bundles: orderData.bundles,
        latitude: double.parse(orderData.latitude),
          longitude: double.parse(orderData.longitude),
        directionName: orderData.directionName,
        status: orderData.orderState,
        totalAmount: orderData.totalAmount,
        orderReport: '',
        subTotal: '0',
        deliveryFee: '0',
        discount: '0',
        currency: orderData.currency,
        paymentMethod: orderData.orderPayment,
        creationDate: orderData.orderCreatedDate.toString(),
        );
      }else {
        throw Exception('Error al obtener la orden con backend verde');
      }
     
    }else{
      throw Exception('Error al obtener la orden');
    }
  }
}