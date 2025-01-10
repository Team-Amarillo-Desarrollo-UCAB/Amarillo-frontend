import 'package:flutter/material.dart';
import '../../Combo/infrastructure/combo_service_search_by_id.dart';
import '../../Producto/infrastructure/product_service_search_by_id.dart';
import '../../common/infrastructure/base_url.dart';
import '../domain/order.dart';
import '../infrastructure/order_service_search_by_id.dart';

class OrderDetailsView extends StatefulWidget {
  final String orderId;

  OrderDetailsView({super.key, required this.orderId});

  @override
  _OrderDetailsViewState createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  bool isOrderLoading = true;

  late Order order;
  final OrderServiceSearchById orderServiceSearchById =
      OrderServiceSearchById(BaseUrl().BASE_URL);
  final ProductServiceSearchbyId _productService =
      ProductServiceSearchbyId(BaseUrl().BASE_URL);
  final ComboServiceSearchById _comboService =
      ComboServiceSearchById(BaseUrl().BASE_URL);

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<List<Map<String, String>>> getProductDetails(
      List<Map<String, dynamic>> items,
      List<Map<String, dynamic>> bundles) async {
    List<Map<String, String>> productDetails = [];
    try {
      for (var item in items) {
        final product = await _productService.getProductById(item['id']);
        final double quantity = double.parse(item['quantity']);
        final double total = double.parse(product.price) * quantity;
        productDetails.add({
          'name': product.name,
          'quantity': item['quantity'],
          'price': total.toString(),
        });
      }
      for (var bundle in bundles) {
        final combo = await _comboService.getComboById(bundle['id']);
        final double quantity = double.parse(bundle['quantity']);
        final double total = double.parse(combo.price) * quantity;
        productDetails.add({
          'name': combo.name,
          'quantity': bundle['quantity'],
          'price': total.toString(),
        });
      }
    } catch (e) {
      productDetails.add(
          {'name': 'Producto no encontrado', 'quantity': '0', 'price': '0'});
    }
    return productDetails;
  }

  Future<void> _fetchOrderDetails() async {
    try {
      final fetchedOrder =
          await orderServiceSearchById.getOrderById(widget.orderId);
      setState(() {
        order = fetchedOrder;
        isOrderLoading = false;
      });
    } catch (e) {
      print('Error obteniendo detalles de la orden: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isOrderLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detalle orden'),
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    final orderStatusDetails = _getOrderStatusDetails(order.status);
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle orden"),
        centerTitle: true,
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
                      side:
                          BorderSide(color: const Color(0xFFFF7622), width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                    "Orden #${order.orderId.substring(order.orderId.length - 4)}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis),
                              ),
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
                                      order.status,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Método de pago: ${order.paymentMethod}",
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
                  FutureBuilder<List<Map<String, String>>>(
                    future: getProductDetails(order.items, order.bundles),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final product = snapshot.data![index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${product['name']} x ${product['quantity']}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "\$${product['price']}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return const Text('No hay productos');
                    },
                  ),
                  Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPriceRow("Subtotal", double.parse(order.subTotal)),
                      _buildPriceRow("Shipping fee", double.parse(order.deliveryFee)),
                      _buildPriceRow("Descuento", double.parse(order.discount)),
                      Divider(),
                      _buildPriceRow("Total", double.parse(order.totalAmount), isTotal: true),
                    ],
                  ),
                  SizedBox(height: 16),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side:
                          BorderSide(color: const Color(0xFFFF7622), width: 2),
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
                                order.creationDate,
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
                                  order.directionName,
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
          if (order.status == "Entregada")
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
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
      case "CREATED" :
        return {
          "icon": Icons.check_circle,
          "iconColor": Colors.green,
          "textColor": Colors.green,
          "backgroundColor": Colors.green[100],
        };
      case "DELIVERED":
        return {
          "icon": Icons.check_circle,
          "iconColor": Colors.green,
          "textColor": Colors.green,
          "backgroundColor": Colors.green[100],
        };
      case "SHIPPED":
        return {
          "icon": Icons.access_time,
          "iconColor": Colors.orange,
          "textColor": Colors.orange,
          "backgroundColor": Colors.orange[100],
        };
      case "CANCELLED":
        return {
          "icon": Icons.cancel,
          "iconColor": Colors.red,
          "textColor": Colors.red,
          "backgroundColor": Colors.red[100],
        };
        case "BEING PROCESSED":
        return {
          "icon": Icons.access_time,
          "iconColor": Colors.orange,
          "textColor": Colors.orange,
          "backgroundColor": Colors.orange[100],
        };
      default:
        return {
          "icon": Icons.help,
          "iconColor": Colors.grey,
          "textColor": Colors.grey,
          "backgroundColor": Colors.grey[100],
        };
    }
  }
}
