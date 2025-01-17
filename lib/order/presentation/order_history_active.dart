import 'package:desarrollo_frontend/Combo/infrastructure/combo_service_search_by_id.dart';
import 'package:desarrollo_frontend/common/presentation/color_extension.dart';
import 'package:desarrollo_frontend/order/presentation/refund_request_view.dart';
import 'package:desarrollo_frontend/order/presentation/track_order_view.dart';
import 'package:flutter/material.dart';
import '../../Producto/infrastructure/product_service_search_by_id.dart';
import '../../common/infrastructure/base_url.dart';
import '../application/order_cancel.dart';
import '../application/refund_dialog.dart';
import '../domain/order.dart';
import '../infrastructure/order-service.dart';
import 'order_summary_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  OrderHistoryScreen({super.key});

  @override
  _HistoryOrderScreenState createState() => _HistoryOrderScreenState();
}

class _HistoryOrderScreenState extends State<OrderHistoryScreen> {
  List<Order> activeOrders = [];
  List<Order> pastOrders = [];
  late final OrderService orderService;
  final ProductServiceSearchbyId _productService = ProductServiceSearchbyId(BaseUrl().BASE_URL);
  final ComboServiceSearchById _comboService = ComboServiceSearchById(BaseUrl().BASE_URL);
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isActiveTab = true; 
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    orderService = OrderService(BaseUrl().BASE_URL);
    fetchOrders(); 
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
    }
  }

  Future<List<String>> getProductNames(List<Map<String, dynamic>> items, List<Map<String, dynamic>> bundles) async {
    List<String> productDetails = [];
    try {
      for (var item in items) {
        final product = await _productService.getProductById(item['id']);
        productDetails.add('${product.name} x ${item['quantity']}');
      }
      for (var bundle in bundles) {
        final combo = await _comboService.getComboById(bundle['id']);
        productDetails.add('${combo.name} x ${bundle['quantity']}');
      }
    } catch (e) {
      productDetails.add('Producto no encontrado');
    }
    return productDetails;
  }

  Future<void> fetchOrders() async {
    try {
      if (_isActiveTab) {
        List<Order> fetchedOrders = await orderService.getOrders(1, ["CREATED","BEING PROCESSED","SHIPPED"]);
        setState(() {
          activeOrders = fetchedOrders;
        });
      } else {
        List<Order> fetchedOrders = await orderService.getOrders(1, ["DELIVERED","CANCELLED"]);
        setState(() {
          pastOrders = fetchedOrders;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar las órdenes: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.secondary,
        title: const Text("Historial de orden",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isActiveTab = true;
                        _hasMore = true;
                        fetchOrders();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isActiveTab ? TColor.primary : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Center(
                          child: Text(
                            "Activas",
                            style: TextStyle(
                              color: _isActiveTab ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isActiveTab = false;
                        _hasMore = true;
                        fetchOrders();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: !_isActiveTab ? TColor.primary : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Center(
                          child: Text(
                            "Pasadas",
                            style: TextStyle(
                              color: !_isActiveTab ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isActiveTab
                ? activeOrders.isEmpty
                    ? const SizedBox( height: 2)
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: _hasMore ? activeOrders.length + 1 : activeOrders.length,
                        itemBuilder: (context, index) {
                          if (index >= activeOrders.length) {
                            return const SizedBox(height: 2);
                          }
                          final order = activeOrders[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailsView(
                                    orderId: order.orderId,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text("Orden #${order.orderId.substring(order.orderId.length - 4)}",
                                        style: const TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(
                                      "\$ ${(order.totalAmount)}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    FutureBuilder<List<String>>(
                                      future: getProductNames(order.items, order.bundles),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        }
                                        if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        }
                                        if (snapshot.hasData) {
                                          return Text(
                                            snapshot.data!.join(", \n"),
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          );
                                        }
                                        return const Text('No hay productos');
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                          onPressed: () {
                                            cancelOrder(context, order.orderId);
                                            Future.delayed(Duration(seconds: 5), () => fetchOrders());
                                          },
                                          child: Text("Cancelar Orden",
                                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => TrackOrderView(
                                                        orderId: order.orderId,
                                                      )),
                                            );
                                          },
                                          child: Text("Track orden", style: TextStyle(color: TColor.primary, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                : pastOrders.isEmpty
                    ? const SizedBox( height: 2)
                    : ListView.builder(
                       controller: _scrollController,
                      itemCount: _hasMore ? pastOrders.length + 1 : pastOrders.length,
                      itemBuilder: (context, index) {
                        if (index >= pastOrders.length) {
                          return const SizedBox(height: 2);
                        }
                        final order = pastOrders[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderDetailsView(
                                  orderId: order.orderId,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    "Orden #${order.orderId.substring(order.orderId.length - 4)}",
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "\$ ${(order.totalAmount)}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  FutureBuilder<List<String>>(
                                    future: getProductNames(order.items, order.bundles),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }
                                      if (snapshot.hasData) {
                                        return Text(
                                          snapshot.data!.join(", \n"),
                                          style: const TextStyle(fontSize: 16),
                                        );
                                      }
                                      return const Text('No hay productos');
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: order.status == "DELIVERED" ? Colors.green[100] : Colors.red[100],
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          order.status,
                                          style: TextStyle(
                                            color: order.status == "DELIVERED" ? Colors.green : Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      if (order.status == "CANCELLED") 
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => RefundRequestView(orderId: order.orderId),
                                              ),
                                            );
                                          },
                                          child: Text(order.orderReport == ' ' 
                                                ? "Reportar" 
                                                : "Reportar", 
                                                style: order.orderReport == ' ' 
                                                ? TextStyle( color: TColor.primary, fontWeight: FontWeight.bold) 
                                                : TextStyle( color: Colors.grey, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                          TextButton(
                                            onPressed: () {
                                              showRefundDialog(context, order.orderId);
                                            },
                                            child: Text(
                                              "Reembolsar",
                                              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
          ),
        ],
      ),
    );
  }
}
