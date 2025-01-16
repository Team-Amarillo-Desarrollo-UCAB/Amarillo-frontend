class Order {
  final String orderId;
  final List<Map<String, dynamic>> items;
  final List<Map<String, dynamic>> bundles;
  final double latitude;
  final double longitude;
  final String directionName;
  late final String status;
  final String totalAmount;
  final String subTotal;
  final String deliveryFee;
  final String discount;
  final String orderReport;
  final String currency;
  final String paymentMethod;
  final String creationDate;

  Order({
    required this.directionName,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.discount,
    required this.currency,
    required this.deliveryFee,
    required this.subTotal,
    required this.orderReport,
    required this.orderId,
    required this.items,
    required this.bundles,
    required this.totalAmount,
    required this.paymentMethod,
    required this.creationDate,
  });

}
