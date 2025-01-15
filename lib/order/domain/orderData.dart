class OrderData {
  final String id;
  final String orderState;
  final DateTime orderCreatedDate;
  final String totalAmount;
  final String subTotal;
  final String shippingFee;
  final String currency;
  final double latitude;
  final double longitude;
  final String directionName;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> bundles;
  final String orderReport;
  final Map<String, dynamic> orderPayment;
  final String orderDiscount;

  OrderData({
    required this.id,
    required this.orderState,
    required this.orderCreatedDate,
    required this.totalAmount,
    required this.subTotal,
    required this.shippingFee,
    required this.currency,
    required this.latitude,
    required this.longitude,
    required this.directionName,
    required this.products,
    required this.bundles,
    required this.orderReport,
    required this.orderPayment,
    required this.orderDiscount,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id']?? 'ERROR01',
      orderState: json['orderState'] ?? ' ',
      orderCreatedDate: json['orderCreatedDate'] != null ? DateTime.parse(json['orderCreatedDate']) : DateTime.now(),
      totalAmount: (json['totalAmount'] ?? 0.0).toString(),
      subTotal: (json['sub_total'] ?? 0.0).toString(),
      shippingFee: (json['shipping_fee'] ?? 0.0).toString(),
      currency: json['currency'] ?? 'USD',
      latitude:(json['orderDirection']['lat']) ?? 0.0,
      longitude: (json['orderDirection']['long']) ?? 0.0,
      directionName: json['directionName'] ?? ' ',
      products: List<Map<String, dynamic>>.from(json['products'] ?? []),
      bundles: List<Map<String, dynamic>>.from(json['bundles'] ?? []),
      orderReport: json['orderReport'] ?? ' ',
      orderPayment: Map<String, dynamic>.from(json['orderPayment'] ?? {}),
      orderDiscount: (json['orderDiscount'] ?? 0.0).toString(),
    );
  }
}
