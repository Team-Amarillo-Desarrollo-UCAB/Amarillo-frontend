class OrderData {
  final String orderId;
  final List<Map<String, dynamic>> products;
  final double totalAmount;
  final String creationDate;
  final String status;

  OrderData({
    required this.orderId,
    required this.products,
    required this.totalAmount,
    required this.creationDate,
    required this.status,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      orderId: json['id_orden'],
      products: (json['productos'] as List<dynamic>)
          .map((product) => product as Map<String, dynamic>)
          .toList(),
      totalAmount: json['monto_total'],
      creationDate: json['fecha_creacion'],
      status: json['estado'],
    );
  }
}