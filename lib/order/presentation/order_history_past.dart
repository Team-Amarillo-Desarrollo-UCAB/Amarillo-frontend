import 'package:desarrollo_frontend/Combo/infrastructure/combo_service_search_by_id.dart';
import 'package:desarrollo_frontend/common/presentation/color_extension.dart';
import 'package:desarrollo_frontend/common/presentation/common_widget/round_button.dart';
import 'package:desarrollo_frontend/order/presentation/track_order_view.dart';
import 'package:desarrollo_frontend/order/presentation/order_summary_screen.dart';
import 'package:flutter/material.dart';
import '../../Producto/infrastructure/product_service_search_by_id.dart';
import '../../common/infrastructure/base_url.dart';
import '../domain/order.dart';
import '../infrastructure/order_service_past.dart';
import 'order_history_active.dart';

class OrderHistoryScreenPast extends StatefulWidget {
  OrderHistoryScreenPast({super.key});

  @override
  _HistoryOrderScreenState createState() => _HistoryOrderScreenState();
}

class _HistoryOrderScreenState extends State<OrderHistoryScreenPast> {
  List<Order> orders = [];
  late final OrderServicePast orderServicePast;
  final ProductServiceSearchbyId _productService = ProductServiceSearchbyId(BaseUrl().BASE_URL);
  final ComboServiceSearchById _comboService = ComboServiceSearchById(BaseUrl().BASE_URL);
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    orderServicePast = OrderServicePast(BaseUrl().BASE_URL);
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


Future<List<String>> getProductNames(List<Map<String, dynamic>> items,List<Map<String, dynamic>> bundles) async {
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
      List<Order>  fetchedOrders = await orderServicePast.getOrdersPast();
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
    List<Order> newOrders = await orderServicePast.getOrdersPast();
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
                    type: RoundButtonType.textPrimary,
                    onPressed: () {
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => OrderHistoryScreen()));
                              },
                  ),
                ),
                Expanded(
                  child: RoundButton(
                    title: "Pasadas",
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
              itemCount: orders.length + (_hasMore ? 1 : 0),
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
                        Text("Orden #${order.orderId.substring(order.orderId.length - 4)}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          "\$ ${(order.totalAmount).toStringAsFixed(1)}",
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




