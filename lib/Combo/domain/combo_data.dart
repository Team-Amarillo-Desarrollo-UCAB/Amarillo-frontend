class ComboData {
  final String id;
  final String name;
  final String description;
  final String price;
  final String currency;
  final List<dynamic> images;
  final String weight;
  final String measurement;
  final List<dynamic> category;
  final List<dynamic> productId;
  final String discount;

  ComboData(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.currency,
      required this.images,
      required this.weight,
      required this.measurement,
      required this.category,
      required this.productId,
      required this.discount});

  factory ComboData.fromJson(Map<String, dynamic> json) {
    return ComboData(
      id: json['id'] ?? 'ERROR01',
      name: json['name'] ?? 'Nombre no disponible',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toString(),
      currency: json['currency'] ?? 'USD',
      images: List<dynamic>.from(json['images'] ?? []),
      weight: (json['weight'] ?? 0).toString(),
      measurement: json['measurement'] ?? '',
      category: List<dynamic>.from(json['categories'] ?? []),
      productId: List<dynamic>.from(json['products'] ?? []),
      discount: json['discount'] ?? '0',
    );
  }
}
