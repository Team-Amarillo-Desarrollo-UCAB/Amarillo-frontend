class CartItem {
  final dynamic imageUrl;
  final String name;
  final double price;
  final String description;
  int quantity;

  CartItem({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.description,
    this.quantity = 1,
  });

  // Función para incrementar la cantidad
  void incrementQuantity() {
    quantity++;
  }

  // Función para decrementar la cantidad
  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }

  void eliminateQuantity() {
    quantity = 0;
  }
}
