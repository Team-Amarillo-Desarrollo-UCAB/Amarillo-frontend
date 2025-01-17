import 'package:desarrollo_frontend/Combo/domain/combo.dart';
import 'package:desarrollo_frontend/statistics/domain/product_data.dart';

import '../../Combo/infrastructure/combo_service.dart';
import '../../Producto/domain/product.dart';
import '../../Producto/infrastructure/product_service.dart';
import '../../order/infrastructure/order-service.dart';
import '../domain/profit_data.dart';
import '../domain/trend_data.dart';

class StatisticsService {
  final ProductService productService;
  final OrderService orderService;
  final ComboService comboService;

  StatisticsService({
    required this.productService,
    required this.orderService,
    required this.comboService,
  });

  Future<List<TrendData>> getPurchaseTrends() async {
    try {
      final orders = await orderService.getAllOrders(100, ["DELIVERED"]);
      Map<int, int> monthlyPurchases = {};

      for (var order in orders) {
        final orderDate = DateTime.parse(order.creationDate);
        final month = orderDate.month;

        if (!monthlyPurchases.containsKey(month)) {
          monthlyPurchases[month] = 0;
        }
        monthlyPurchases[month] = monthlyPurchases[month]! + 1;
      }

      return monthlyPurchases.entries.map((entry) {
        return TrendData(
          x: entry.key.toDouble(),
          actual: entry.value.toDouble(),
          target: 100.0, // Por ejemplo, el objetivo puede ser un valor fijo
        );
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener las tendencias de compra: $e');
    }
  }

  Future<List<ProfitData>> getMostPurchasedCategories() async {
    try {
      final products = await productService.getProducts(1);
      final combos = await comboService.getCombo(1);
      final orders = await orderService.getAllOrders(100, ["DELIVERED"]);

      Map<String, double> categoryCount = {};

      for (var order in orders) {
        for (var product in order.items) {
          final matchedProduct = products.firstWhere(
            (p) => p.id_product == product['id'],
            orElse: () => Product(
              id_product: '',
              name: 'Desconocido',
              images: [],
              price: "0.0",
              description: '',
              peso: '',
              category: [],
              discount: "0.0",
              image3d: '',
            ),
          );

          final category = matchedProduct.category.join(', ');
          if (!categoryCount.containsKey(category)) {
            categoryCount[category] = 0.0;
          }
          categoryCount[category] = categoryCount[category]! + 1.0;
        }
      }

      return categoryCount.entries.map((entry) {
        return ProfitData(
          name: entry.key,
          value: entry.value,
        );
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener las categorías más compradas: $e');
    }
  }

  Future<List<ProductData>> getMostPurchasedProducts() async {
    try {
      final products = await productService.getProducts(1);
      final combos = await comboService.getCombo(1); // Obtén la lista de combos
      final orders = await orderService.getAllOrders(100, ["DELIVERED"]);

      Map<String, double> productCount = {};

      for (var order in orders) {
        for (var product in order.items) {
          // Busca en productos y combos
          final matchedProduct = products.firstWhere(
            (p) => p.id_product == product['id'],
            orElse: () => 
            Product(
              id_product: '',
              name: 'Desconocido',
              images: [],
              price: "0.0",
              description: '',
              peso: '',
              category: [],
              discount: "0.0",
              image3d: '',
            ),
          );

          // Prioriza productos y luego combos
          final productName = matchedProduct?.name ?? '';

          if (productName.isNotEmpty) {
            if (!productCount.containsKey(productName)) {
              productCount[productName] = 0.0;
            }
            productCount[productName] = productCount[productName]! +
                (product['quantity'] as num).toDouble();
          }
        }

        for (var product in order.bundles) {
          // Busca en productos y combos


          final matchedCombo = combos.firstWhere(
            (c) => c.id_product == product['id'],
            orElse: () => Combo(
              id_product: '',
              name: 'Desconocido',
              images: [],
              price: "0.0",
              description: '',
              peso: '',
              category: [],
              discount: "0.0", 
              productId: [],
            ),
          );

          // Prioriza productos y luego combos
          final productName = matchedCombo?.name ?? '';

          if (productName.isNotEmpty) {
            if (!productCount.containsKey(productName)) {
              productCount[productName] = 0.0;
            }
            productCount[productName] = productCount[productName]! +
                (product['quantity'] as num).toDouble();
          }
        }
      }

      return productCount.entries.map((entry) {
        return ProductData(
          name: entry.key,
          quantity: entry.value,
        );
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener los productos más comprados: $e');
    }
  }
}

