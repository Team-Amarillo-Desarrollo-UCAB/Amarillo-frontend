class Cupon {
  final String code;
  final DateTime expirationDate;
  final double amount;
  bool used;

  Cupon({
    required this.code,
    required this.expirationDate,
    required this.amount,
    required this.used,
  });
}
