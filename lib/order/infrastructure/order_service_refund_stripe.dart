import 'package:http/http.dart' as http;
import '../../common/infrastructure/tokenUser.dart';

class OrderAskRefund {
  final String baseUrl;

  OrderAskRefund(this.baseUrl);

  Future<Response> askRefund(String orderId) async {
    final url = Uri.parse('$baseUrl/order/refund/stripe/$orderId');
    final token = await TokenUser().getToken();

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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
}

class Response {
  final bool isSuccessful;
  final String? errorMessage;

  Response({required this.isSuccessful, this.errorMessage});
}