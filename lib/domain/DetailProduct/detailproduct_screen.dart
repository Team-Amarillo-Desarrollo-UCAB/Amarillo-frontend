import 'package:desarrollo_frontend/domain/home/popular_product.dart';
import 'package:flutter/material.dart';

class DetailProductScreen extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const DetailProductScreen(
      {super.key, required this.product, required this.onAdd});

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
              backgroundImage: product.image as ImageProvider<Object>,
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
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              'Agregar al carrito',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w900,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox.shrink(),
        ],
      ),
    );
  }
}
