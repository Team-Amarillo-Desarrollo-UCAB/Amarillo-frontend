class Descuento {
  final String id;
  final String name;
  final String description;
  final double percentage;
  final dynamic image;
  final DateTime fechaExp;

  Descuento({
    required this.id,
    required this.name,
    required this.description,
    required this.percentage,
    required this.image,
    required this.fechaExp,
  });
}
