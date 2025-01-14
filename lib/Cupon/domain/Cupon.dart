class Cupon {
  final String code;
  final DateTime expirationDate;
  final String amount;
  bool used;
  int use;

  Cupon({
    required this.code,
    required this.expirationDate,
    required this.amount,
    required this.used,
    required this.use,
  });
}
