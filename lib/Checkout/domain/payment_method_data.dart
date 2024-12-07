class PaymentData{
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