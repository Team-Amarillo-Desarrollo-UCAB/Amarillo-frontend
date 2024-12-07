import 'package:flutter/material.dart';

class OrderDetailsView extends StatelessWidget {
  final String orderId = "#221342";
  final String orderStatus = "Entregado"; 
  final String paymentMethod = "Efectivo"; 
  final List<Map<String, dynamic>> items = [
    {"name": "Harina pan", "quantity": 2, "price": 7.00},
    {"name": "Nestea - Durazno", "quantity": 1, "price": 1.50},
    {"name": "Almuerzo familiar", "quantity": 2, "price": 30.00},
    {"name": "Desayuno familiar", "quantity": 2, "price": 30.00},
  ];
  final double subtotal = 138.50;
  final double shippingFee = 25.00;
  final double discount = 0.00;
  final String deliveryTime = "Entregado hoy a las 3:00 PM";
  final String deliveryLocation = "Universidad Católica Andrés Bello";

  OrderDetailsView(String orderId);

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
