import 'package:flutter/material.dart';
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
  final String orderStatus = "Entregado";
  final String paymentMethod = "PayPal";

  late Order order;
  final OrderServiceSearchById orderServiceSearchById =
      OrderServiceSearchById(BaseUrl().BASE_URL);

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    try {
      final fetchedOrder =
          await orderServiceSearchById.getOrderById(widget.orderId);
      setState(() {
        order = fetchedOrder;
      });
    } catch (e) {
      print('Error obteniendo detalles de la orden: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderStatusDetails = _getOrderStatusDetails(orderStatus);

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
                                child: Text("Orden #${order.orderId}",
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
                    itemCount: order.items.length,
                    itemBuilder: (context, index) {
                      final item = order.items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "${item['id']} x ${item['quantity']}",
                                style: TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text("el precio es 10",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      );
                    },
                  ),
                  Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPriceRow("Subtotal", order.subTotal),
                      _buildPriceRow("Shipping fee", order.deliveryFee),
                      _buildPriceRow("Descuento", order.discount.toDouble()),
                      Divider(),
                      _buildPriceRow("Total", order.totalAmount, isTotal: true),
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
          if (orderStatus == "Entregado")
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
