class CategoryData {
  final String id;
  final String name;
  final dynamic image;

  CategoryData({required this.id, required this.name, required this.image});

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['id'] ?? 'ERROR01',
      image: json['image'] ??
          'https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg',
      name: json['name'] ?? 'Estoy aqui?',
    );
  }
}
