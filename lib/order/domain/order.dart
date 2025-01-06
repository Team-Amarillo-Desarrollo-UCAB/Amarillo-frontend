class Order {
  final String orderId;
  final List<Map<String, dynamic>> items;
  final List<Map<String, dynamic>> bundles;
  final double latitude;
  final double longitude;
  final String directionName;
  final String status;
  final double totalAmount;
  final double subTotal;
  final double deliveryFee;
  final int discount;
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
    required this.orderId,
    required this.items,
    required this.bundles,
    required this.totalAmount,
    required this.paymentMethod,
    required this.creationDate,
  });

}
