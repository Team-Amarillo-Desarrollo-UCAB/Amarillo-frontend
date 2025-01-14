import 'package:desarrollo_frontend/Producto/infrastructure/product_service_search_by_id.dart';
import 'package:desarrollo_frontend/Producto/presentation/DetailProduct/detailproductcart_screen.dart';
import 'package:desarrollo_frontend/common/infrastructure/base_url.dart';
import 'package:flutter/material.dart';
import '../../common/presentation/color_extension.dart';
import '../domain/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onRemoveItem;
  final ProductServiceSearchbyId _productServiceSearchbyId =
      ProductServiceSearchbyId(BaseUrl().BASE_URL);

  CartItemWidget(
      {super.key,
      required this.item,
      required this.onAdd,
      required this.onRemove,
      required this.onRemoveItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showDetailCartItemDialog(context, item, _productServiceSearchbyId);
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
                        radius: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Text(
                                '${item.price.toStringAsFixed(2)} \$',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                                        backgroundColor: TColor.secondary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        minimumSize: const Size(25, 25),
                                        padding: EdgeInsets.zero),
                                    child: Icon(Icons.remove,
                                        color: TColor.white),
                                  ),
                                  Text(item.quantity.toString(),
                                      style: const TextStyle(fontSize: 15)),
                                  ElevatedButton(
                                    onPressed: onAdd,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: TColor.primary,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      minimumSize: const Size(20, 20),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Icon(Icons.add,
                                        color: TColor.white),
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
