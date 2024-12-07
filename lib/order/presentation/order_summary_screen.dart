import 'package:desarrollo_frontend/Carrito/infrastructure/cart_service.dart';
import 'package:flutter/material.dart';

import '../../Carrito/domain/cart_item.dart';
import '../../Carrito/presentation/cart_screen.dart';
import '../../Producto/presentation/popular_product_widget.dart';

class OrderDetailsView extends StatelessWidget {
  final CartService _cartService = CartService();
  final String orderId = "#08900b6f";
  final String orderStatus = "Entregado"; 
  final String paymentMethod = "PayPal"; 
  final List<Map<String, dynamic>> items = [
    {"name": "Cochino", "quantity": 1, "price": 4.00},
    {"name": "Pañales", "quantity": 1, "price": 10.0},
    {"name": "Bolígrafo", "quantity": 1, "price": 0.50},

  ];
  final double subtotal = 14.50;
  final double shippingFee = 0.00;
  final double discount = 0.00;
  final String deliveryTime = "Entregado hoy a las 3:00 PM";
  final String deliveryLocation = "Universidad Católica Andrés Bello";

  @override
  Widget build(BuildContext context) {
    
    final double total = subtotal + shippingFee - discount;
    
    final orderStatusDetails = _getOrderStatusDetails(orderStatus);

    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle orden"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: const Color(0xFFFF7622), width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Orden $orderId",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: orderStatusDetails['backgroundColor'],
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      orderStatusDetails['icon'],
                                      color: orderStatusDetails['iconColor'],
                                      size: 16,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      orderStatus,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: orderStatus == "Entregado"
                                              ? Colors.green
                                              : Colors.orange),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Método de pago: $paymentMethod",
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Items
                  Text("Items",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${item['name']} x ${item['quantity']}",
                              style: TextStyle(fontSize: 14),
                            ),
                            Text("\$${item['price']}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      );
                    },
                  ),
                  Divider(),
                  // Subtotal, Shipping, Descuento, Total
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPriceRow("Subtotal", subtotal),
                      _buildPriceRow("Shipping fee", shippingFee),
                      _buildPriceRow("Descuento", discount),
                      Divider(),
                      _buildPriceRow("Total", total, isTotal: true),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Hora y lugar
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: const Color(0xFFFF7622), width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 16),
                              SizedBox(width: 8),
                              Text(
                                deliveryTime,
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.location_pin, size: 16),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  deliveryLocation,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Botón Reordenar
          if (orderStatus == "Entregado")
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
 ProductCard(
                                onAdd: () => onAdd(
CartItem(
    id_product: "07ef12b4-9759-493e-b644-5b29f3aa9c19",
    imageUrl: null,
    name: "Cochino",
    price: 4.0, // Convertimos el precio a tipo double
    description: "comida",
    peso: "1 kg", // Concatenamos cantidad y unidad de medida
  );
  CartItem(
    id_product: "0c84343b-c9a9-4c5a-b680-9405391dbbc6",
    imageUrl: "https://res.cloudinary.com/dxttqmyxu/image/upload/v1731484573/sgsqquwni3pnipaxilky.jpg",
    name: "Bolígrafo",
    price: 0.5,
    description: "Bolígrafo azul",
    peso: "10 g",
  );
  CartItem(
    id_product: "0a86ad7d-fa64-4cb6-910c-a282aba331fa",
    imageUrl: "https://res.cloudinary.com/dxttqmyxu/image/upload/v1731483519/txhouysijwq9dz7db1wx.png",
    name: "Pañales",
    price: 10.0,
    description: "Pañales para bebé",
    peso: "500 g",
  );
                  Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => CartScreen(
                                    //orderId: 'order.orderId',
                                    )));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Center(
                  child: Text("Reordenar",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, 
            ),
          ),
          Text(
            "\$${value.toStringAsFixed(2)}", 
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
  
  Map<String, dynamic> _getOrderStatusDetails(String status) {
    switch (status) {
      case "Entregado":
        return {
          "icon": Icons.check_circle,
          "iconColor": Colors.green,
          "textColor": Colors.green,
          "backgroundColor": Colors.green[100],
        };
      case "En camino":
        return {
          "icon": Icons.access_time,
          "iconColor": Colors.orange,
          "textColor": Colors.orange,
          "backgroundColor": Colors.orange[100],
        };
      case "Cancelado":
        return {
          "icon": Icons.cancel,
          "iconColor": Colors.red,
          "textColor": Colors.red,
          "backgroundColor": Colors.red[100],
        };
      case "En proceso":
      default:
        return {
          "icon": Icons.pending,
          "iconColor": Colors.blue,
          "textColor": Colors.blue,
          "backgroundColor": Colors.blue[100],
        };
    }
  }
}

void onAdd(CartItem item) async {
    await _cartService.loadCartItems();
    bool isProductInCart =
        _cartService.cartItems.any((cartItem) => cartItem.name == item.name);
    if (isProductInCart) {
      CartItem existingItem = _cartService.cartItems
          .firstWhere((cartItem) => cartItem.name == item.name);
      existingItem.incrementQuantity();
    } else {
      _cartService.cartItems.add(item);
    }
    await _cartService.saveCartItems();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isProductInCart
            ? '${item.name} cantidad incrementada'
            : '${item.name} añadido al carrito'),
        duration: const Duration(seconds: 2),
      ),
    );
  }





