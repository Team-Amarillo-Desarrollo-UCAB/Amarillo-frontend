import 'package:desarrollo_frontend/Combo/domain/combo.dart';
import 'package:desarrollo_frontend/Combo/presentation/detailcombo_screen.dart';
import 'package:desarrollo_frontend/Descuento/Domain/Descuento.dart';
import 'package:desarrollo_frontend/Descuento/Infrastructure/descuento_service_search_by_id.dart';
import 'package:desarrollo_frontend/Producto/infrastructure/product_service_search_by_id.dart';
import 'package:desarrollo_frontend/common/infrastructure/base_url.dart';
import 'package:flutter/material.dart';

class ComboCard extends StatefulWidget {
  final Combo combo;
  final VoidCallback onAdd;
  ComboCard({
    super.key,
    required this.combo,
    required this.onAdd,
  });
  @override
  _ComboCardState createState() => _ComboCardState();
}

class _ComboCardState extends State<ComboCard> {
  final ProductServiceSearchbyId _productServiceSearchbyId =
      ProductServiceSearchbyId(BaseUrl().BASE_URL);

  final DescuentoServiceSearchById _descuentoServiceSearchById =
      DescuentoServiceSearchById(BaseUrl().BASE_URL);
  Descuento? _descuento;

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _fetchDescuento();
  }

  Future<void> _fetchDescuento() async {
    if (widget.combo.discount != "9bd9532c-5033-4621-be8a-87de4934a0be") {
      setState(() {
        _isLoading = true;
      });
      try {
        final descuento = await _descuentoServiceSearchById
            .getDescuentoById(widget.combo.discount);
        setState(() {
          _descuento = descuento;
        });
      } catch (error) {
        print('Error al obtener el descuento: $error');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDetailComboDialog(
            context, widget.combo, widget.onAdd, _productServiceSearchbyId);
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: _descuento != null
              ? BorderSide(color: Colors.yellow, width: 2)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    widget.combo.images[0] as ImageProvider<Object>,
                radius: 40,
              ),
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
                            widget.combo.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        _isLoading
                            ? CircularProgressIndicator()
                            : _descuento != null
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'En descuento',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      Text(
                                        '${(double.parse(widget.combo.price) * (1 - _descuento!.percentage / 100)).toStringAsFixed(2)} \$',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    '${widget.combo.price} \$',
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
                        Text(widget.combo.peso,
                            style: const TextStyle(fontSize: 16)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: widget.onAdd,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
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
          ),
        ),
      ),
    );
  }
}
