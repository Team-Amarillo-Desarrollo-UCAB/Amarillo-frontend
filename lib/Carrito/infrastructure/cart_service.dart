import 'dart:convert';
import 'package:desarrollo_frontend/common/infrastructure/tokenUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/infrastructure/base_url.dart';
import '../domain/cart_item.dart';
import 'package:http/http.dart' as http;

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;

  CartService._internal();

  List<CartItem> _cartItems = [];
  final List<CartItem> initialCartItems = [];

  List<CartItem> get cartItems => _cartItems;

  String? _idOrder;
  List<Map<String, dynamic>>? orderItems;
  String? get idOrder => _idOrder;

  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsString = prefs.getString('cart_items');

    if (cartItemsString == null) {
      _cartItems = List<CartItem>.from(initialCartItems);
    } else {
      final List<dynamic> jsonItems = jsonDecode(cartItemsString);
      _cartItems =
          jsonItems.map((jsonItem) => CartItem.fromJson(jsonItem)).toList();
    }
  }

  Future<void> saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonItems = _cartItems.map((item) => item.toJson()).toList();
    prefs.setString('cart_items', jsonEncode(jsonItems));
  }

  void removeItem(CartItem item) {
    _cartItems.remove(item);
    saveCartItems();
  }

  Future<void> clearCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart_items');
    _cartItems = List<CartItem>.from(initialCartItems);
    saveCartItems();
  }

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
      String cuponCode,
      String instructions) async {
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

    final body = jsonEncode({
      'idPayment': idPayment,
      'paymentMethod': paymentMethod,
      if (tokenStripe != null) 'token': tokenStripe,
      'orderReciviedDate': orderReceivedDate.toIso8601String().split('T')[0],
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'products': productItems,
      'combos': bundleItems,
      'cupon_code': cuponCode,
      'instructions': instructions,
    });

    final Uri url = Uri.parse(BaseUrl().BASE_URL + '/order/create');

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
