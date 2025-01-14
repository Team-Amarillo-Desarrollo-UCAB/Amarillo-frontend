import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../common/infrastructure/tokenUser.dart';

class OrderServiceChangeState {
  final String baseUrl;

  OrderServiceChangeState(this.baseUrl);

  Future<Response> changeOrderState(Map<String, dynamic> body, String orderId) async {
    final url = Uri.parse('$baseUrl/order/change/state/$orderId');
    final token = await TokenUser().getToken();

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

  Future<Response> cancelOrder(String orderId) async {
    final Map<String, dynamic> body = {
      "orderState": "CANCELLED",
    };
    return await changeOrderState(body, orderId);
  }
}
class Response {
  final bool isSuccessful;
  final String? errorMessage;

  Response({required this.isSuccessful, this.errorMessage});
}
