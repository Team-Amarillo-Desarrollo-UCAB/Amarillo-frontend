import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/infrastructure/base_url.dart';
import '../domain/cart_item.dart';
import 'package:http/http.dart' as http;

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  

  CartService._internal(); // Constructor privado usando singleton

  List<CartItem> _cartItems = [];
  final List<CartItem> initialCartItems = [];
  
  List<CartItem> get cartItems => _cartItems;

  String? _idOrder; // Atributo para almacenar el id de la orden
  List<Map<String, dynamic>>? orderItems;
  String? get idOrder => _idOrder; // Getter para obtener el id de la orden

  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsString = prefs.getString('cart_items');

    if (cartItemsString == null) {
      // Si no hay datos guardados, usar los valores iniciales sin guardar en SharedPreferences
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
    await prefs.remove(
        'cart_items'); // Elimina los datos del carrito en SharedPreferences
    _cartItems = List<CartItem>.from(initialCartItems);
    saveCartItems(); // Restaura el carrito a su estado inicial
  }

  Future<void> createOrder(List<CartItem> cartItems) async {
    orderItems = cartItems
        .map((item) => {
              'id_producto': item.id_product,
              'nombre_producto': item.name,
              'cantidad_producto': item.quantity,
            })
        .toList();

    final body = jsonEncode({
      'entry': orderItems,
    });

    final Uri url = Uri.parse(BaseUrl().BASE_URL+'/order/create');

    final response = await http
        .post(url, body: body, headers: {'Content-Type': 'application/json'});

    if (response.statusCode != 201) {
      throw Exception('Error al crear la orden: ${response.statusCode}');
    }

    // Decodifica el JSON de la respuesta
    final Map<String, dynamic> responseData = jsonDecode(response.body);

    // Guarda el ID de la orden en _idOrder
    _idOrder = responseData['id_order'];
  }
}
