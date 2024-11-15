import 'package:desarrollo_frontend/domain/Carrito/cart_item.dart';
import 'package:flutter/material.dart';

class DetailProductCartScreen extends StatelessWidget {
  final CartItem product; // Recibe un mapa con los datos del producto

  const DetailProductCartScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            product.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          CircleAvatar(
              backgroundImage: product.imageUrl as ImageProvider<Object>,
              radius: 80),
          // Muestra la imagen del producto
          const SizedBox(height: 16),
          Text(
            product.description,
            style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w900,
                fontSize: 15,
                color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centra el Row horizontalmente
            children: [
              const Text(
                'Precio:',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 8), // Espacio entre "Precio:" y el valor
              Text(
                '${product.price} USD',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                product.peso,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const SizedBox.shrink(),
        ],
      ),
    );
  }
}
