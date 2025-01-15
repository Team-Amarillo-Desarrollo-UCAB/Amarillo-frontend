class Combo {
  final String id_product;
  final List<dynamic> images;
  final String name;
  final String price;
  final List<dynamic> productId;
  final String peso;
  final String description;
  final String discount;
  final List<dynamic> category;

  Combo(
      {required this.id_product,
      required this.images,
      required this.name,
      required this.price,
      required this.description,
      required this.peso,
      required this.productId,
      required this.discount,
      required this.category});
}
