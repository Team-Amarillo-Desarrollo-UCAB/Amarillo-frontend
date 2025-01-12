import 'package:flutter/material.dart';

class CartItem {
  final String id_product;
  final dynamic imageUrl;
  final String name;
  final double price;
  final dynamic description;
  final String peso;
  int quantity;
  final bool isCombo;
  final List<dynamic>? productId;
  final String discount;
  final List<dynamic> category;

  CartItem({
    required this.id_product,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.description,
    required this.peso,
    this.quantity = 1,
    this.productId,
    required this.isCombo,
    required this.discount,
    required this.category,
  });

  void incrementQuantity() {
    quantity++;
  }

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
      'id_product': id_product,
      'imageUrl': imageUrl.url,
      'name': name,
      'price': price,
      'description': description,
      'peso': peso,
      'quantity': quantity,
      'productId': productId,
      'isCombo': isCombo,
      'category': category,
      'discount': discount,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id_product: json['id_product'],
      imageUrl: NetworkImage(json['imageUrl']),
      name: json['name'],
      price: json['price'],
      description: json['description'],
      peso: json['peso'],
      quantity: json['quantity'],
      productId: json['productId'],
      isCombo: json['isCombo'],
      category: json['category'],
      discount: json['discount'],
    );
  }
}
