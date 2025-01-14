class CuponData {
  final String code;
  final String expirationDate;
  final String amount;
  final bool used;
  final int use;

  CuponData(
      {required this.code,
      required this.expirationDate,
      required this.amount,
      required this.used,
      required this.use});

  factory CuponData.fromJson(Map<String, dynamic> json) {
    return CuponData(
      code: json['code'] ?? 'ERROR01',
      expirationDate: json['expiration_date'] ?? '1970-01-01T00:00:00.000Z',
      amount: (json['amount'] ?? 0).toString(),
      used: false,
      use: 3,
    );
  }
}
