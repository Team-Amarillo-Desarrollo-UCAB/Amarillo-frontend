
import 'package:flutter/material.dart';
import '../home/popular_product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const ProductCard({
    super.key, 
    required this.product,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                      children: [
                      CircleAvatar(backgroundImage: product.image as ImageProvider<Object>, radius: 40),//CircleAvatar
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(product.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    Text('${product.price} \$', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(product.description, style: const TextStyle(fontSize: 16)),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                       ElevatedButton(
                                          onPressed: onAdd,
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[200],shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          minimumSize: const Size(20, 20),
                                          padding: EdgeInsets.zero,
                                          ),
                                          child: const Icon(Icons.add, color: Colors.white),
                                          ),
                                          ],
                                  )
                                ],
                              )
                            ],
                          ),
                         )
                      ],
                  )
                )
              );
  }





}