class DescuentoData {
  final String id;
  final String name;
  final String description;
  final double percentage;

  DescuentoData({
    required this.id,
    required this.name,
    required this.description,
    required this.percentage,
  });

  factory DescuentoData.fromJson(Map<String, dynamic> json) {
    return DescuentoData(
      id: json['id'] ?? 'ERROR01',
      name: json['name'] ?? 'Nombre no disponible',
      description: json['description'] ?? '',
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }
}
