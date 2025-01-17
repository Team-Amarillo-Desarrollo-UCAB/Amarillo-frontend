import 'package:desarrollo_frontend/order/domain/orderDataGreen.dart';
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
  print("Código de respuesta amarillo: ${response.statusCode}"); // Debug

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
    List<Order> allOrders = [];
  
  for (String s in status) {
    String url = '$baseUrl/order/many?status=$s';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print("Estado: $s, Código de respuesta orange: ${response.statusCode}"); // Debug

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);

        allOrders.addAll(decodedData.map((json) {
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
        }));
      } else {
        print("Error al obtener órdenes para el estado para el backend naranja $s");
      }
    } catch (e) {
      print("Error al llamar al endpoint para el estado $s: $e");
    }
  }

  return allOrders;
}else if(baseUrl == 'https://godelybackgreen.up.railway.app/api') {
  if(status.contains('CREATED') || (status.contains('BEING PROCESSED') || (status.contains('SHIPPED')))){
    final url = Uri.parse('$baseUrl/order/many/active');
    final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print(status);
      print("Código de respuesta verde: ${response.statusCode}"); 
    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);
      print(decodedData); 

      return decodedData.map((json) {
        final orderData = OrderDataGreen.fromJson(json);
        return Order(
          orderId: orderData.id,
          items: orderData.products,
          bundles: orderData.bundles,
          latitude: double.parse(orderData.latitude),
          longitude: double.parse(orderData.longitude),
          directionName: orderData.directionName,
          status: orderData.orderState,
          totalAmount: orderData.totalAmount,
          orderReport: 'No hay reporte',
          subTotal: '0',
          deliveryFee: '0',
          discount: '0',
          currency: orderData.currency,
          paymentMethod: orderData.orderPayment,
          creationDate: orderData.orderCreatedDate.toString(),
        );
      }).toList();
  } else {
    throw Exception('Error al obtener las órdenes con backend Verde en activas');
  }
  }else{
      final url = Uri.parse('$baseUrl/order/many/past');
    final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print(status);
      print("Código de respuesta verde past: ${response.statusCode}"); 
    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);

      return decodedData.map((json) {
        final orderData = OrderDataGreen.fromJson(json);
        return Order(
          orderId: orderData.id,
          items: orderData.products,
          bundles: orderData.bundles,
          latitude: double.parse(orderData.latitude),
          longitude: double.parse(orderData.longitude),
          directionName: orderData.directionName,
          status: orderData.orderState,
          totalAmount: orderData.totalAmount,
          orderReport: 'No hay reporte',
          subTotal: '0',
          deliveryFee: '0',
          discount: '0',
          currency: orderData.currency,
          paymentMethod: orderData.orderPayment,
          creationDate: orderData.orderCreatedDate.toString(),
        );
      }).toList();
  } else {
    throw Exception('Error al obtener las órdenes con backend Verde');
  }
  }
}else{
  throw Exception('Error al obtener las órdenes de los backends');
}
}


Future<List<Order>> getAllOrders(int perpage, List<String> status) async {
  final token = await TokenUser().getToken();
    if(baseUrl == 'https://amarillo-backend-production.up.railway.app') {
        String url = '$baseUrl/order/many?page=1&?&perpage=$perpage';
    
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
    List<Order> allOrders = [];
  
  for (String s in status) {
    String url = '$baseUrl/order/many?status=$s';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print("Estado: $s, Código de respuesta: ${response.statusCode}"); // Debug

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);

        allOrders.addAll(decodedData.map((json) {
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
        }));
      } else {
        print("Error al obtener órdenes para el estado para el backend naranja $s");
      }
    } catch (e) {
      print("Error al llamar al endpoint para el estado $s: $e");
    }
  }


  // Retornar todas las órdenes obtenidas
  return allOrders;
}else if(baseUrl == 'https://godelybackgreen.up.railway.app/api') {
  if(status == ['CREATED', 'BEING PROCESSED', 'SHIPPED']){
    print(status);
    final url = Uri.parse('$baseUrl/order/many/active');
    final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print("Código de respuesta: ${response.statusCode}"); 
    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> decodedData = json.decode(response.body);
      print(decodedData); 

      return decodedData.map((json) {
        final orderData = OrderDataGreen.fromJson(json);
        return Order(
          orderId: orderData.id,
          items: orderData.products,
          bundles: orderData.bundles,
          latitude: double.parse(orderData.latitude),
          longitude: double.parse(orderData.longitude),
          directionName: orderData.directionName,
          status: orderData.orderState,
          totalAmount: orderData.totalAmount,
          orderReport: ' ',
          subTotal: '0',
          deliveryFee: '0',
          discount: '0',
          currency: orderData.currency,
          paymentMethod: orderData.orderPayment,
          creationDate: orderData.orderCreatedDate.toString(),
        );
      }).toList();
  } else {
    throw Exception('Error al obtener las órdenes con backend Verde en activas');
  }
  }else{
      final url = Uri.parse('$baseUrl/order/many/past');
    final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print("Código de respuesta: ${response.statusCode}"); 
    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);

      return decodedData.map((json) {
        final orderData = OrderDataGreen.fromJson(json);
        return Order(
          orderId: orderData.id,
          items: orderData.products,
          bundles: orderData.bundles,
          latitude: double.parse(orderData.latitude),
          longitude: double.parse(orderData.longitude),
          directionName: orderData.directionName,
          status: orderData.orderState,
          totalAmount: orderData.totalAmount,
          orderReport: ' ',
          subTotal: '0',
          deliveryFee: '0',
          discount: '0',
          currency: orderData.currency,
          paymentMethod: orderData.orderPayment,
          creationDate: orderData.orderCreatedDate.toString(),
        );
      }).toList();
  } else {
    throw Exception('Error al obtener las órdenes con backend Verde');
  }
  }
}else{
  throw Exception('Error al obtener las órdenes de los backends');
}
}
}
