import 'dart:convert';
import 'package:desarrollo_frontend/common/infrastructure/tokenUser.dart';
import '../domain/cart_item.dart';
import 'package:http/http.dart' as http;

class CartServiceCreateOrder {
  final String baseUrl;
  String? _idOrder;
  String? get idOrder => _idOrder;

  CartServiceCreateOrder(this.baseUrl);

  Future<void> createOrder(
      String idPayment,
      String paymentMethod,
      String? tokenStripe,
      DateTime orderReceivedDate,
      String address,
      double latitude,
      double longitude,
      List<CartItem> products,
      List<CartItem> combos,
      String? cuponCode,
      String instructions,
      double total) async {
    final token = await TokenUser().getToken();
    final List<Map<String, dynamic>> productItems = products
        .map((item) => {
              'id': item.id_product,
              'quantity': item.quantity,
            })
        .toList();
    final List<Map<String, dynamic>> bundleItems = combos
        .map((item) => {
              'id': item.id_product,
              'quantity': item.quantity,
            })
        .toList();

    final bodyAmarillo = jsonEncode({
      'idPayment': idPayment,
      'paymentMethod': paymentMethod,
      if (tokenStripe != null) 'token': tokenStripe,
      'orderReciviedDate': orderReceivedDate.toIso8601String().split('T')[0],
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'products': productItems,
      'combos': bundleItems,
      if (cuponCode != null) 'cuponCode': cuponCode,
      'instructions': instructions,
    });

    final bodyOrange = jsonEncode({
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'products': productItems,
      'combos': bundleItems,
      'paymentMethod': paymentMethod,
      'currency': 'USD',
      'total': total,
      if (cuponCode != null) 'cupon_Code': cuponCode,
    });

    final body = baseUrl == 'https://amarillo-backend-production.up.railway.app'
        ? bodyAmarillo
        : bodyOrange;

    final Uri url = Uri.parse('$baseUrl/order/create');

    final response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 201) {
      throw Exception(
          'Error al crear la orden: ${response.statusCode}, ${body}');
    }

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    _idOrder = responseData['id'];
  }
}
