import 'package:desarrollo_frontend/domain/Carrito/cart_item.dart';
import 'package:flutter/material.dart';

class DetailProductScreen extends StatelessWidget {
  final CartItem product; // Recibe un mapa con los datos del producto

  const DetailProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        // Utiliza el nombre del producto como título
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                  backgroundImage: product.imageUrl as ImageProvider<Object>,
                  radius: 40),
              // Muestra la imagen del producto
              const SizedBox(height: 16),
              Text(
                product.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Precio: ${product.price} USD',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // Agrega aquí otros detalles del producto, como características, reseñas, etc.
              // Por ejemplo:
              const Text('Características:'),
              // Utiliza una lista o un ListView.builder para mostrar las características
              const SizedBox(height: 16),
              // Botón para agregar al carrito o realizar otras acciones
              ElevatedButton(
                onPressed: () {
                  // Lógica para agregar el producto al carrito
                },
                child: const Text('Agregar al carrito'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
