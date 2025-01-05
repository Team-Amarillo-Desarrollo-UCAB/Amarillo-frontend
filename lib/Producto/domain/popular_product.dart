class Product {
  final String id_product;
  final String name;
  final double price;
  final String description;
  final String peso;
  final List<dynamic> images;
  final List<dynamic> category;
  final String discount;

  Product(
      {required this.id_product,
      required this.images,
      required this.name,
      required this.price,
      required this.description,
      required this.peso,
      required this.category,
      required this.discount});
}
