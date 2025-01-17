import 'package:desarrollo_frontend/descuento/domain/descuento.dart';
import 'package:desarrollo_frontend/descuento/infrastructure/descuento_service_search_by_id.dart';
import 'package:desarrollo_frontend/Producto/domain/product.dart';
import 'package:desarrollo_frontend/Producto/presentation/DetailProduct/detailproduct_screen.dart';
import 'package:desarrollo_frontend/common/infrastructure/base_url.dart';
import 'package:desarrollo_frontend/common/presentation/main_tabview.dart';
import 'package:flutter/material.dart';

import '../../common/presentation/color_extension.dart';
import 'product_individual_view.dart';

class ProductCard2 extends StatefulWidget {
  final Product product;
  final VoidCallback onAdd;
  ProductCard2({
    super.key,
    required this.product,
    required this.onAdd,
  });
  @override
  _ProductCard2State createState() => _ProductCard2State();
}

class _ProductCard2State extends State<ProductCard2> {
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
    if (widget.product.discount != "" && mounted) {
      setState(() {
        _isLoading = true;
      });
      try {
        final descuento = await _descuentoServiceSearchById
            .getDescuentoById(widget.product.discount);
        final now = DateTime.now();

        if (now.isBefore(descuento.fechaExp)) {
          if (mounted) {
            setState(() {
              _descuento = descuento;
              _isLoading = false;
            });
          }
        } else {
          print(
              'El descuento no es válido porque la fecha de expedición es posterior a la fecha actual.');
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      } catch (error) {
        print('Error al obtener el descuento: $error');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PerfumeDetailPage(product: widget.product),
            // builder: (context) => PerfumeDetailPage(),
          ),
        );
      },
      onLongPress: () {
        // Muestra el diálogo al mantener presionado
        showDetailProductDialog(context, widget.product, widget.onAdd);
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: _descuento != null
              ? BorderSide(color: TColor.secondary, width: 2)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    widget.product.images[0] as ImageProvider<Object>,
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
                            widget.product.name,
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
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: TColor.primary,
                                        ),
                                      ),
                                      Text(
                                        '${(double.parse(widget.product.price) * (1 - _descuento!.percentage / 100)).toStringAsFixed(2)} \$',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: TColor.primary,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    '${widget.product.price} \$',
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
                        Text(widget.product.peso,
                            style: const TextStyle(fontSize: 16)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: widget.onAdd,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TColor.primary,
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
