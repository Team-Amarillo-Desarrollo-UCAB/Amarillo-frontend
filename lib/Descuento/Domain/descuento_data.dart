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
            'https://res.cloudinary.com/dxttqmyxu/image/upload/v1736998301/mimsoiff4abol3t809oz.png',
        fechaExp: json['expireDate'] ?? "2026-01-16T23:59:59.999Z");
  }
}
