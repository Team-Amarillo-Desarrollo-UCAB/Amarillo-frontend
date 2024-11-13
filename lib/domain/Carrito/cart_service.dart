import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_item.dart';
import 'package:flutter/material.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;

  CartService._internal(); // Constructor privado usando singleton

  List<CartItem> _cartItems = [];
  final List<CartItem> initialCartItems = [
    CartItem(
      imageUrl: const NetworkImage('https://web.superboom.net/web/image/product.product/34120/image_128'),
      name: 'Harina Pan',
      price: 10.5,
      description: '1 kg',
    ),
    CartItem(
      imageUrl: const NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgUqCgTNTnh9nIX_FnzrDfssfSaGMb9PVeMQ&s'),
      name: 'Nestle - Limón',
      price: 1.5,
      description: '120 gr',
    ),
    CartItem(
      imageUrl: const NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgUqCgTNTnh9nIX_FnzrDfssfSaGMb9PVeMQ&s'),
      name: 'Nestle - Durazno',
      price: 1.5,
      description: '120 gr',
    ),
    CartItem(
      imageUrl: const NetworkImage('https://images.rappi.com/products/ccb54d3a-0595-4627-bdbf-2c95887555ff.png?e=webp&q=80&d=130x130'),
      name: 'Almuerzo Familiar',
      price: 30.0,
      description: 'Combo',
    ),
    CartItem(
      imageUrl: const NetworkImage('https://images.rappi.com/products/ccb54d3a-0595-4627-bdbf-2c95887555ff.png?e=webp&q=80&d=130x130'),
      name: 'Almuerzo Familiar',
      price: 25.0,
      description: 'Combo',
    ),
    CartItem(
      imageUrl: const NetworkImage('https://images.rappi.com/products/ccb54d3a-0595-4627-bdbf-2c95887555ff.png?e=webp&q=80&d=130x130'),
      name: 'Almuerzo',
      price: 32.0,
      description: 'Combo',
    ),
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
