// checkout_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../common/infrastructure/base_url.dart';
import '../../Carrito/domain/cart_item.dart';

class CheckoutService {
  static final CheckoutService _instance = CheckoutService._internal();
  factory CheckoutService() => _instance;

  CheckoutService._internal(); 

  String? _idOrder;

  String? get idOrder => _idOrder; 

  Future<void> createOrder(List<CartItem> cartItems) async {
    final List<Map<String, dynamic>> orderItems = cartItems
        .map((item) => {
              'id_producto': item.id_product,
              'nombre_producto': item.name,
              'cantidad_producto': item.quantity,
            })
        .toList();

    final body = jsonEncode({
      'entry': orderItems,
    });

    final Uri url = Uri.parse(BaseUrl().BASE_URL);

    final response = await http.post(url, body: body, headers: {'Content-Type': 'application/json'});

    if (response.statusCode != 201) {
      throw Exception('Error al crear la orden: ${response.statusCode}');
    }

    final Map<String, dynamic> responseData = jsonDecode(response.body);
    _idOrder = responseData['id_order'];
  }
}
