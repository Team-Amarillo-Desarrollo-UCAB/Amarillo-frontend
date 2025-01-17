class OrderDataGreen {
  final String id;
  final String orderState;
  final DateTime orderCreatedDate;
  final String totalAmount;
  final String currency;
  final double latitude;
  final double longitude;
  final String directionName;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> bundles;
  final String orderPayment;
  final String orderDiscount;

  OrderDataGreen({
    required this.id,
    required this.orderState,
    required this.orderCreatedDate,
    required this.totalAmount,
    required this.currency,
    required this.latitude,
    required this.longitude,
    required this.directionName,
    required this.products,
    required this.bundles,
    required this.orderPayment,
    required this.orderDiscount,
  });

  factory OrderDataGreen.fromJson(Map<String, dynamic> json) {
    return OrderDataGreen(
      id: json['id']?? 'ERROR01',
      orderState: json['status'] ?? ' ',
      orderCreatedDate: json['createdDate'] != null ? DateTime.parse(json['orderCreatedDate']) : DateTime.now(),
      totalAmount: (json['total'] ?? 0.0).toString(),
      currency: json['currency'] ?? 'USD',
      latitude:(json['latitude']) ?? 0.0,
      longitude: (json['longitude']) ?? 0.0,
      directionName: json['address'] ?? ' ',
      products: List<Map<String, dynamic>>.from(json['products'] ?? []),
      bundles: List<Map<String, dynamic>>.from(json['combos'] ?? []),
      orderPayment: json['paymentMethod'] ?? ' ',
      orderDiscount: (json['orderDiscount'] ?? 0.0).toString(),
    );
  }
}
