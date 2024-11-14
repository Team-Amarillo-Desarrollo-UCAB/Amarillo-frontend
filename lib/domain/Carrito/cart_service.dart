import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_item.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;

  CartService._internal(); // Constructor privado usando singleton

  List<CartItem> _cartItems = [];
  final List<CartItem> initialCartItems = [
  ];

  List<CartItem> get cartItems => _cartItems;

  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsString = prefs.getString('cart_items');

    if (cartItemsString == null) {
      // Si no hay datos guardados, usar los valores iniciales sin guardar en SharedPreferences
      _cartItems = List<CartItem>.from(initialCartItems);
    } else {
      final List<dynamic> jsonItems = jsonDecode(cartItemsString);
      _cartItems = jsonItems.map((jsonItem) => CartItem.fromJson(jsonItem)).toList();
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
    await prefs.remove('cart_items');  // Elimina los datos del carrito en SharedPreferences
    _cartItems = List<CartItem>.from(initialCartItems);
    saveCartItems();  // Restaura el carrito a su estado inicial
  }
}
