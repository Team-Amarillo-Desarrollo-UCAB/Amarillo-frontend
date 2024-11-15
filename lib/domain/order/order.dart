class Order {
  final String? orderId;
  final List<Map<String, dynamic>>? items;
  final String status = "Procesando la orden";

  Order({
    required this.orderId,
    required this.items
  });

}
