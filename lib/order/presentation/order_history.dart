import 'package:desarrollo_frontend/common/presentation/color_extension.dart';
import 'package:desarrollo_frontend/common/presentation/common_widget/round_button.dart';
import 'package:desarrollo_frontend/order/presentation/track_order_view.dart';
import 'package:flutter/material.dart';

import '../../common/infrastructure/base_url.dart';
import '../infrastructure/order-service.dart';
import 'order_summary_screen.dart'; 

class OrderHistoryScreen extends StatefulWidget {
  OrderHistoryScreen({super.key});

  @override
  _HistoryOrderScreenState createState() => _HistoryOrderScreenState();
}

class _HistoryOrderScreenState extends State<OrderHistoryScreen> {
  List<Order> orders = [];
  late final OrderService orderService;
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    orderService = OrderService(BaseUrl().BASE_URL);
    fetchOrders(); 
    //_loadMoreOrders();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

  }

@override
void dispose() {
  _scrollController.dispose();
  super.dispose();
}

void _onScroll() {
  if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 && 
      !_isLoading &&
      _hasMore) {
    _loadMoreOrders();
  }
}




  Future<void> fetchOrders() async {
    try {
      List<Order>  fetchedOrders = await orderService.getOrders(1);
      setState(() {
        orders = fetchedOrders;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar las órdenes: $e')),
      );
    }
  }

void _loadMoreOrders() async {
  if (_isLoading || !_hasMore) return;
  setState(() => _isLoading = true);
  try {
    List<Order> newOrders = await orderService.getOrders(_page);
    setState(() {
        if (newOrders.isEmpty) {
          _hasMore = false;
        } else {
          orders.addAll(newOrders);
          _page++;
        }
      });

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al cargar más órdenes: $e')),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}

/*
 Future<void> _loadMoreProducts() async {
    if (_isLoading || !_hasMore) return;
    setState(() {
      _isLoading = true;
    });
    try {
      List<Product> newProducts = await _productService.getProducts(_page);
      setState(() {
        if (newProducts.isEmpty) {
          _hasMore = false;
        } else {
          _product.addAll(newProducts);
          _page++;
        }
      });
    } catch (error) {
      print('Error al obtener productos: $error');
    }

    setState(() {
      _isLoading = false;
    });
  }



*/



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
            child: 
            orders.isEmpty ? const Center(child: CircularProgressIndicator()) : 
            ListView.builder(
              controller: _scrollController,
              itemCount: _hasMore ? orders.length + 1 : orders.length,
              itemBuilder: (context, index) {
                if (index >= orders.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final order = orders[index];
                return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailsView(
                              orderId: order.orderId
                            ),
                          ),
                        );
                      },
        child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Orden",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("Nº${order.orderId}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          "\$ ${double.parse(order.totalAmount).toStringAsFixed(1)}",
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
                              onPressed: () {
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => TrackOrderView(orderId: order.orderId)));
                              },
                              child: Text("Track orden",
                                  style: TextStyle(color: TColor.primary)),
                            ),
                          ],
                        ),
                      ],
                    ),
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
  final String totalAmount;
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
      totalAmount: json['monto_total'],
      creationDate: DateTime.parse(json['fecha_creacion']),
      status: json['estado'],
    );
  }
}

class Product {
  final String name;
  final String quantity;

  Product({
    required this.name,
    required this.quantity,
  });

 
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['nombre_producto'] ?? "Producto desconocido", 
      quantity: json['cantidad_producto'] ?? "1", 
    );
  }

  
}



