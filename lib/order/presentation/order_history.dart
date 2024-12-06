import 'package:desarrollo_frontend/common/presentation/color_extension.dart';
import 'package:desarrollo_frontend/common/presentation/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../common/infrastructure/base_url.dart'; 

class OrderHistoryScreen extends StatefulWidget {
  OrderHistoryScreen({super.key});

  @override
  _HistoryOrderScreenState createState() => _HistoryOrderScreenState();
}

class _HistoryOrderScreenState extends State<OrderHistoryScreen> {
  final List<Order> orders = [];
  late final OrderService orderService;

  @override
  void initState() {
    super.initState();
    orderService = OrderService(BaseUrl().BASE_URL);
    fetchOrders(); // Carga los datos al iniciar
  }

  // Simula la obtención de datos del endpoint
  Future<void> fetchOrders() async {
    try {
      final fetchedOrders = await orderService.getOrders();
      setState(() {
        orders.addAll(fetchedOrders);
      });
    } catch (e) {
      // Manejo de errores, por ejemplo, mostrar un snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar las órdenes: $e')),
      );
    }
  }

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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Order #${order.orderId}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          "\$ ${order.totalAmount.toStringAsFixed(2)}",
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.products
                              .map((item) => "${item.name} (${item.quantity})")
                              .join(", "),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: order.status == "CREATED"
                                    ? Colors.green[100]
                                    : Colors.orange[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                order.status,
                                style: TextStyle(
                                  color: order.status == "CREATED"
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: Text("Cancelar Orden",
                                  style:
                                      TextStyle(color: TColor.secondaryText)),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text("Ver Detalles",
                                  style: TextStyle(color: TColor.primary)),
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




class Order {
  final String orderId;
  final List<Product> products;
  final double totalAmount;
  final DateTime creationDate;
  final String status;

  Order({
    required this.orderId,
    required this.products,
    required this.totalAmount,
    required this.creationDate,
    required this.status,
  });

  // Método para crear una instancia desde un JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['id_orden'],
      products: (json['productos'] as List<dynamic>)
          .map((product) => Product.fromJson(product))
          .toList(),
      totalAmount: json['monto_total'].toDouble(),
      creationDate: DateTime.parse(json['fecha_creacion']),
      status: json['estado'],
    );
  }
}

class Product {
  final String name;
  final int quantity;

  Product({
    required this.name,
    required this.quantity,
  });

  // Método para crear una instancia desde un JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['nombre'] ?? "Producto desconocido", // Fallback si no hay nombre
      quantity: json['cantidad'] ?? 1,
    );
  }
}

class OrderService {
  final String baseUrl;

  OrderService(this.baseUrl);

  /// Obtiene todas las órdenes
  Future<List<Order>> getOrders() async {
    final response = await http.get(Uri.parse('$baseUrl/order/many'));

    if (response.statusCode == 200) {
      // Decodifica el cuerpo como un Map
      final Map<String, dynamic> decodedData = json.decode(response.body);

      // Verifica que la clave "orders" exista y sea una lista
      if (decodedData.containsKey('orders') && decodedData['orders'] is List) {
        final List<dynamic> ordersData = decodedData['orders'];
        return ordersData
            .map<Order>((jsonOrder) => Order.fromJson(jsonOrder))
            .toList();
      } else {
        throw Exception(
            'El formato de respuesta no es válido: no contiene una lista de órdenes.');
      }
    } else {
      throw Exception('Error al obtener las órdenes');
    }
  }

  /// Obtiene una orden específica por ID
  Future<Order> getOrderById(String orderId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/order/one?orderId=$orderId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return Order.fromJson(data);
    } else {
      throw Exception('Error al obtener la orden con ID $orderId');
    }
  }
}

