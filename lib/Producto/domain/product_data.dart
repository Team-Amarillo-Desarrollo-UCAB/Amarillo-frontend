class ProductData {
  final String id_product;
  final String name;
  final String price;
  final String unitMeasure;
  final double quantity;
  final String description;
  final List<dynamic> images;
  final List<dynamic> category;
  final String discount;

  ProductData(
      {required this.id_product,
      required this.images,
      required this.name,
      required this.description,
      required this.price,
      required this.unitMeasure,
      required this.quantity,
      required this.category,
      required this.discount});

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      id_product: json['id'] ?? 'ERROR01',
      images: List<dynamic>.from(json['images'] ??
          [
            'https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg'
          ]),
      name: json['name'] ?? 'Nombre no disponible',
      description: json['description'] ?? '',
      price: json['price'] ?? '0',
      unitMeasure: json['measurement'] ?? '',
      quantity: double.parse(json['weight'] ?? '0'),
      category: List<String>.from(json['category'] ?? []),
      discount: json['discount'] ?? '0',
    );
  }
}
