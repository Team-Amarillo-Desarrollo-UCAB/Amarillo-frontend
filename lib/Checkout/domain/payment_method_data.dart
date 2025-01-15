class PaymentData {
  final String id_payment;
  final String name;

  PaymentData({required this.id_payment, required this.name});

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      id_payment: json['idPayment'] ?? 'ERROR01',
      name: json['name'] ?? 'Nombre no disponible',
    );
  }
}

class PaymentDataGreen {
  final String idPayment;
  final String name;

  PaymentDataGreen({
    required this.idPayment,
    required this.name,
  });

  factory PaymentDataGreen.fromJson(Map<String, dynamic> json) {
    return PaymentDataGreen(
      idPayment: json['id'],
      name: json['name'],
    );
  }
}
