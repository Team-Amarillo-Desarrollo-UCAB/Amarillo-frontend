import '../Carrito/cart_item.dart';

class Order {
  final String orderId;
  final List<CartItem> items;
  final String status;

  Order({
    required this.orderId,
    required this.items,
    required this.status,
  });

  double get total {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
}
