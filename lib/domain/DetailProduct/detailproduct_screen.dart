import 'package:desarrollo_frontend/domain/home/popular_product.dart';
import 'package:flutter/material.dart';

void showDetailProductDialog(
    BuildContext context, Product product, VoidCallback onAdd) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del contenido
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
              const SizedBox(height: 16),
              CircleAvatar(
                  backgroundImage: product.image as ImageProvider<Object>,
                  radius: 80),
              const SizedBox(height: 16),
              const Text(
                'Descripción:',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Precio:',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
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
                  )
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
            ],
          ),
        );
      });
}
