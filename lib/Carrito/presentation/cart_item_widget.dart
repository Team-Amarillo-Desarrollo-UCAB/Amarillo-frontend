import 'package:desarrollo_frontend/Producto/presentation/DetailProduct/detailproductcart_screen.dart';
import 'package:flutter/material.dart';
import '../domain/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onRemoveItem;

  const CartItemWidget(
      {super.key,
      required this.item,
      required this.onAdd,
      required this.onRemove,
      required this.onRemoveItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showDetailCartItemDialog(context, item);
        },
        child: Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                        backgroundImage: item.imageUrl as ImageProvider<Object>,
                        radius: 40), //CircleAvatar
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Text('${item.price} \$',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.peso,
                                  style: const TextStyle(fontSize: 16)),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: onRemove,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange[200],
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        minimumSize: const Size(25, 25),
                                        padding: EdgeInsets.zero),
                                    child: const Icon(Icons.remove,
                                        color: Colors.white),
                                  ),
                                  Text(item.quantity.toString(),
                                      style: const TextStyle(fontSize: 15)),
                                  ElevatedButton(
                                    onPressed: onAdd,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange[200],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      minimumSize: const Size(20, 20),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Icon(Icons.add,
                                        color: Colors.white),
                                  ),
                                  IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: onRemoveItem),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ))));
  }
}
