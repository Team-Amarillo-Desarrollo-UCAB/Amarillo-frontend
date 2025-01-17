import 'package:desarrollo_frontend/Combo/domain/combo.dart';
import 'package:desarrollo_frontend/Producto/domain/product.dart';
import 'package:desarrollo_frontend/common/infrastructure/base_url.dart';
import 'package:desarrollo_frontend/descuento/infrastructure/descuento_service_search_by_id.dart';

class DescuentoUsecase {
  final DescuentoServiceSearchById _descuentoServiceSearchById =
      DescuentoServiceSearchById(BaseUrl().BASE_URL);

  Future<double> getDiscountedPriceCombo(Combo combo) async {
    if (combo.discount != "") {
      try {
        final descuento =
            await _descuentoServiceSearchById.getDescuentoById(combo.discount);
        final now = DateTime.now();

        if (now.isBefore(descuento.fechaExp)) {
          return double.parse(combo.price) * (1 - descuento.percentage);
        } else {
          print(
              'El descuento no es válido porque la fecha de expedición es posterior a la fecha actual.');
        }
      } catch (error) {
        print('Error al obtener el descuento: $error');
      }
    }
    return double.parse(combo.price);
  }

  Future<double> getDiscountedPriceProduct(Product product) async {
    if (product.discount != "") {
      try {
        final descuento = await _descuentoServiceSearchById
            .getDescuentoById(product.discount);
        final now = DateTime.now();

        if (now.isBefore(descuento.fechaExp)) {
          return double.parse(product.price) * (1 - descuento.percentage);
        } else {
          print(
              'El descuento no es válido porque la fecha de expedición es posterior a la fecha actual.');
        }
      } catch (error) {
        print('Error al obtener el descuento: $error');
      }
    }
    return double.parse(product.price);
  }
}
