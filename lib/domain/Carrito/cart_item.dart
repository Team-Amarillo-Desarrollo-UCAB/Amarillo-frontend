import 'package:flutter/material.dart';

class CartItem {
  final dynamic imageUrl;
  final String name;
  final double price;
  final String description;
  int quantity;

  CartItem({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.description,
    this.quantity = 1,
  });
  

  // Función para incrementar la cantidad
  void incrementQuantity() {
    quantity++;
  }

  // Función para decrementar la cantidad
  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }

  void eliminateQuantity() {
    quantity = 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl.url,
      'name': name,
      'price': price,
      'description': description,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      imageUrl: NetworkImage(json['imageUrl']),
      name: json['name'],
      price: json['price'],
      description: json['description'],
      quantity: json['quantity'],
    );
  }
}

