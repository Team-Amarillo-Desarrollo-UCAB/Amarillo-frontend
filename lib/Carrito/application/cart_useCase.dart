import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:desarrollo_frontend/Carrito/domain/cart_item.dart';
import 'package:desarrollo_frontend/common/presentation/custom_error_message.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartUsecase {
  List<CartItem> _cartItems = [];
  final List<CartItem> initialCartItems = [];

  List<CartItem> get cartItems => _cartItems;

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

  void onAddCart(CartItem item, BuildContext context) async {
    await loadCartItems();
    bool isProductInCart =
        cartItems.any((cartItem) => cartItem.name == item.name);
    if (isProductInCart) {
      CartItem existingItem =
          cartItems.firstWhere((cartItem) => cartItem.name == item.name);
      existingItem.incrementQuantity();
    } else {
      cartItems.add(item);
    }
    await saveCartItems();
    SnackbarUtil.showAwesomeSnackBar(
        context: context,
        title: 'Listo!',
        message: isProductInCart
            ? '${item.name} cantidad incrementada'
            : '${item.name} añadido al carrito',
        contentType: ContentType.success);
  }
}
