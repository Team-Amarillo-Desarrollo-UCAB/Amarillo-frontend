class OrderDataOrange {
  final String id;
  final DateTime createdDate;
  final String status;
  final String address;
  final double latitude;
  final double longitude;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> combos;
  final DateTime receivedDate;
  final Map<String, dynamic> paymentMethod;
  final Map<String, dynamic> report;
  final DateTime cancelledDate;
  final DateTime shippedDate;
  final DateTime beignProcessedDate;

  const OrderDataOrange({
    required this.id,
    required this.createdDate,
    required this.status,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.products,
    required this.combos,
    required this.receivedDate,
    required this.paymentMethod,
    required this.report,
    required this.cancelledDate,
    required this.shippedDate,
    required this.beignProcessedDate,
  });

  factory OrderDataOrange.fromJson(Map<String, dynamic> json) {
    try {
      return OrderDataOrange(
        id: json['id'] ?? '',
        createdDate: json['createdDate'] != null ? DateTime.parse(json['createdDate']) : DateTime.now(),
        status: json['status'] ?? 'UNKNOWN',
        address: json['address'] ?? 'Sin dirección',
        latitude: json['latitude'] ?? 0.0,
        longitude: json['longitude'] ?? 0.0,
        receivedDate: DateTime.parse(json['receivedDate']),
        products: List<Map<String, dynamic>>.from(json['products'] ?? []),
        combos: List<Map<String, dynamic>>.from(json['combos'] ?? []),
        // products: (json['products'] as List<dynamic>)
        //     .map((item) => CartProduct.fromJson(item))
        //     .toList(),
        // combos: (json['combos'] as List<dynamic>)
        //     .map((item) => CartCombo.fromJson(item))
        //     .toList(),
        paymentMethod: Map<String, dynamic>.from(json['paymentMethod'] ?? {}), 
        report: Map<String, dynamic>.from(json['report'] ?? {}),
        cancelledDate: json['cancelledDate'] != null ? DateTime.parse(json['cancelledDate']) : DateTime.now(),
        shippedDate: json['shippedDate'] != null ? DateTime.parse(json['shippedDate']) : DateTime.now(),
        beignProcessedDate: json['beignProcessedDate'] != null ? DateTime.parse(json['beignProcessedDate']) : DateTime.now(),
      );
    } catch (e) {
      print("Error al deserializar Order: $e");
      throw Exception("Error al procesar el JSON de Order");
    }
  }
}