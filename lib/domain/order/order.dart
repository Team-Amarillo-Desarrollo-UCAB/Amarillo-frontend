import 'order_item.dart';

class Order {
  final String orderId;
  final List<OrderItem> items;
  final String status = "Procesando la orden";

  Order({
    required this.orderId,
    required this.items
  });

}
