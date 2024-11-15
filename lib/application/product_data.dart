class ProductData {
  final String id_product;
  final String imageUrl;
  final String name;
  final String description;
  final double price;
  final String unitMeasure;
  final double quantity;

  ProductData({
    required this.id_product,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.price,
    required this.unitMeasure,
    required this.quantity,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      id_product: json['id_product'] ?? 'no tengo id xd',
      imageUrl: json['image'] ??
          'https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg',
      name: json['nombre'] ?? 'Nombre no disponible',
      description: json['descripcion'] ?? '',
      price: double.parse(json['precio'] ?? '0'),
      unitMeasure: json['unidad_medida'] ?? '',
      quantity: double.parse(json['cantidad_medida'] ?? '0'),
    );
  }
}
