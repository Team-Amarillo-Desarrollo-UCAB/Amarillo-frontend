class CategoryData {
  final String categoryID;
  final String categoryName;
  final dynamic categoryImage;

  CategoryData(
      {required this.categoryID,
      required this.categoryName,
      required this.categoryImage});

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      categoryID: json['categoryID'] ?? 'ERROR01',
      categoryImage: json['categoryImage'] ??
          'https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg',
      categoryName: json['categoryName'] ?? 'Nombre no disponible',
    );
  }
}
