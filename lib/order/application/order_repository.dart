import '../domain/order.dart';

class OrderRepository {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.add(order);
  }
}
