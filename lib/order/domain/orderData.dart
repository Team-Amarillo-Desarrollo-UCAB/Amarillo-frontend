class OrderData {
  final String id;
  final String orderState;
  final DateTime orderCreatedDate;
  final double totalAmount;
  final double subTotal;
  final double shippingFee;
  final String currency;
  final Map<String, dynamic> orderDirection;
  final String directionName;
  final List<Map<String, dynamic>> products;
  final List<dynamic> bundles;
  final DateTime orderReciviedDate;
  final String orderReport;
  final Map<String, dynamic> orderPayment;
  final int orderDiscount;

  OrderData({
    required this.id,
    required this.orderState,
    required this.orderCreatedDate,
    required this.totalAmount,
    required this.subTotal,
    required this.shippingFee,
    required this.currency,
    required this.orderDirection,
    required this.directionName,
    required this.products,
    required this.bundles,
    required this.orderReciviedDate,
    required this.orderReport,
    required this.orderPayment,
    required this.orderDiscount,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id']?? 'ERROR01',
      orderState: json['orderState'] ?? ' ',
      orderCreatedDate: DateTime.parse(json['orderCreatedDate'] ?? ' '),
      totalAmount: double.parse(json['totalAmount'] ?? '0.0'),
      subTotal: double.parse(json['sub_total'] ?? '0.0'),
      shippingFee: double.parse(json['shipping_fee'] ?? '0.0'),
      currency: json['currency'] ?? 'USD',
      orderDirection: {
        "lat": json['orderDirection']['lat']  ?? '0.0',
        "long": json['orderDirection']['long'] ?? '0.0',
      },
      directionName: json['directionName'] ?? ' ',
      products: List<Map<String, dynamic>>.from(json['products'] ?? []),
      bundles: List<dynamic>.from(json['bundles'] ?? []),
      orderReciviedDate: DateTime.parse(json['orderReciviedDate'] ?? ' '),
      orderReport: json['orderReport'] ?? ' ',
      orderPayment: Map<String, dynamic>.from(json['orderPayment'] ?? {}),
      orderDiscount: int.parse(json['orderDiscount'] ?? '0'),
    );
  }
}
