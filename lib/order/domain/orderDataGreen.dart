class OrderDataGreen {
  final String id;
  final String orderState;
  final DateTime orderCreatedDate;
  final String totalAmount;
  final String currency;
  final String latitude;
  final String longitude;
  final String directionName;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> bundles;
  final String orderPayment;

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
  });

  factory OrderDataGreen.fromJson(Map<String, dynamic> json) {
    return OrderDataGreen(
      id: json['id'] ?? 'ERROR01',
      orderCreatedDate: json['createdDate'] != null ? DateTime.parse(json['createdDate']) : DateTime.now(),
      directionName: json['address'] ?? 'MI CASA',
      longitude: (json['longitude']) ?? 0.0,
      latitude: (json['latitude']) ?? 0.0,
      currency: json['currency'] ?? 'USD',
      totalAmount: (json['total'] ?? 0.0).toString(),
      orderPayment: json['paymentMethod'] ?? 'CASH',
      orderState: json['status'] ?? 'CREATED',
      products: List<Map<String, dynamic>>.from(json['products'] ?? []),
      bundles: List<Map<String, dynamic>>.from(json['combos'] ?? []),
    );
  }
}
