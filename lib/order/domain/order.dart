class Order {
  final String? orderId;
  final List<Map<String, dynamic>>? items;
  final String status = "Procesando la orden";
  final double totalAmount;
  final String creationDate;

  Order({
    required this.orderId,
    required this.items,
    required this.totalAmount,
    required this.creationDate,
  });

}
