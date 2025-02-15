class DescuentoData {
  final String id;
  final String name;
  final String description;
  final double percentage;
  final dynamic image;
  final String fechaExp;

  DescuentoData(
      {required this.id,
      required this.name,
      required this.description,
      required this.percentage,
      required this.image,
      required this.fechaExp});

  factory DescuentoData.fromJson(Map<String, dynamic> json) {
    return DescuentoData(
        id: json['id'] ?? 'ERROR01',
        name: json['name'] ?? 'Nombre no disponible',
        description: json['description'] ?? '',
        percentage: (json['percentage'] ?? 0).toDouble(),
        image: json['image'] ??
            'https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg',
        fechaExp: json['expireDate'] ?? "2026-01-16T23:59:59.999Z");
  }
}
