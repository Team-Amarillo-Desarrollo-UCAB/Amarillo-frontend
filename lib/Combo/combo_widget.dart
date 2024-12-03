import 'package:desarrollo_frontend/Combo/combo.dart';
import 'package:desarrollo_frontend/Producto/DetailProduct/detailcombo_screen.dart';
import 'package:flutter/material.dart';

class ComboCard extends StatelessWidget {
  final Combo combo;
  final VoidCallback onAdd;

  const ComboCard({
    super.key,
    required this.combo,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showDetailComboDialog(context, combo, onAdd);
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
                        backgroundImage: combo.image as ImageProvider<Object>,
                        radius: 40), //CircleAvatar
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(combo.name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Text('${combo.price} \$',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(combo.peso,
                                  style: const TextStyle(fontSize: 16)),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
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
