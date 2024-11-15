import 'package:desarrollo_frontend/common/color_extension.dart';
import 'package:desarrollo_frontend/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import '../Carrito/cart_item.dart';
import 'order.dart'; // Importa la nueva clase Order

class OrderHistoryScreen extends StatelessWidget {
  final List<Order> orders = [
    Order(
      orderId: "12990234",
      status: "En Camino",
      items: [
        CartItem(
          name: "Nestle Koko Krunch Breakfast Cereal",
          price: 50.0,
          quantity: 2,
          imageUrl: "https://via.placeholder.com/150",
          description: "A delicious breakfast cereal",
        ),
        CartItem(
          name: "Fresh Refined Sugar",
          price: 20.0,
          quantity: 2,
          imageUrl: "https://via.placeholder.com/150",
          description: "Sugar for daily use",
        ),
      ],
    ),
    Order(
      orderId: "167868237",
      status: "Procesando la orden",
      items: [
        CartItem(
          name: "Peanut Butter",
          price: 80.0,
          quantity: 2,
          imageUrl: "https://via.placeholder.com/150",
          description: "Smooth and creamy peanut butter",
        ),
        CartItem(
          name: "Mozarella Cheese",
          price: 120.0,
          quantity: 1,
          imageUrl: "https://via.placeholder.com/150",
          description: "Cheese for pizzas and more",
        ),
      ],
    ),
  ];

  OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de orden"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: RoundButton(
                    title: "Activas",
                    onPressed: () {},
                  ),
                ),
                Expanded(
                  child: RoundButton(
                    title: "Pasadas",
                    type: RoundButtonType.textPrimary,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Order #${order.orderId}",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          "\$ ${order.total.toStringAsFixed(2)}",
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.items.map((item) => "${item.name} (${item.quantity})").join(", "),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: order.status == "En Camino"
                                    ? Colors.green[100]
                                    : Colors.orange[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                order.status,
                                style: TextStyle(
                                  color: order.status == "En Camino"
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: Text("Cancelar Orden", style: TextStyle(color: TColor.secondaryText)),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text("Ver Detalles", style: TextStyle(color: TColor.primary)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}