import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../common/infrastructure/tokenUser.dart';

class OrderServiceChangeState {
  final String baseUrl;

  OrderServiceChangeState(this.baseUrl);

  Future<Response> changeOrderState(Map<String, dynamic> body, String orderId) async {
    final token = await TokenUser().getToken();
    if(baseUrl == 'https://amarillo-backend-production.up.railway.app') {
    final url = Uri.parse('$baseUrl/order/change/state/$orderId');

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Response(isSuccessful: true);
    } else {
      return Response(
        isSuccessful: false,
        errorMessage: response.body,
      );
    }
  }else if(baseUrl == 'https://orangeteam-deliverybackend-production.up.railway.app') {
    final url = Uri.parse('$baseUrl/order/update/$orderId');

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Response(isSuccessful: true);
    } else {
      return Response(
        isSuccessful: false,
        errorMessage: response.body,
      );
    }
  }else if((baseUrl == 'https://godelybackgreen.up.railway.app/api')) {
    final url = Uri.parse('$baseUrl/order/update/$orderId');

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Response(isSuccessful: true);
    } else {
      return Response(
        isSuccessful: false,
        errorMessage: response.body,
      );
    }
    
  }
    return Response(isSuccessful: false, errorMessage: 'Error al cambiar el estado de la orden');
  }

  Future<Response> changeState(String orderId, String orderstate) async {
    if(baseUrl == 'https://amarillo-backend-production.up.railway.app') {
      final Map<String, dynamic> body = {
        "orderState": orderstate
      };
      return await changeOrderState(body, orderId);
    }else if(baseUrl == 'https://orangeteam-deliverybackend-production.up.railway.app') {
      final Map<String, dynamic> body = {
        "status": "CANCELLED",
      };
      return await changeOrderState(body, orderId);
    }else if('https://godelybackgreen.up.railway.app/api' == baseUrl) {
      final Map<String, dynamic> body = {
        "status": "CANCELLED",
      };
      return await changeOrderState(body, orderId); 
    }else{
      return Response(isSuccessful: false, errorMessage: 'Error al cambiar el estado de la orden');
    }
  }
}
class Response {
  final bool isSuccessful;
  final String? errorMessage;

  Response({required this.isSuccessful, this.errorMessage});
}
