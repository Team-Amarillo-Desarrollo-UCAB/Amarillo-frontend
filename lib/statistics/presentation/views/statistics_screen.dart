import 'package:desarrollo_frontend/Combo/infrastructure/combo_service.dart';
import 'package:desarrollo_frontend/statistics/domain/product_data.dart';
import 'package:flutter/material.dart';
import '../../../Producto/infrastructure/product_service.dart';
import '../../../common/presentation/color_extension.dart';
import '../../../order/infrastructure/order-service.dart';
import '../../application/get_profit_usecase.dart';
import '../../domain/profit_data.dart';
import '../../domain/trend_data.dart';
import 'sales_analysis_view.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);
  

  Future<Map<String, dynamic>> fetchStatistics() async {
    final productService = ProductService('https://amarillo-backend-production.up.railway.app');
    final orderService = OrderService('https://amarillo-backend-production.up.railway.app');
    final comboService = ComboService('https://amarillo-backend-production.up.railway.app');
    final statisticsService = StatisticsService(
      productService: productService,
      orderService: orderService,
      comboService: comboService,
    );

    final trends = await statisticsService.getPurchaseTrends();
    final categories = await statisticsService.getMostPurchasedCategories();
    final products = await statisticsService.getMostPurchasedProducts();

    return {
      'trends': trends,
      'categories': categories,
      'products': products,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.secondary,
        centerTitle: true,
        title: const Text('Estadísticas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchStatistics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar las estadísticas: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            final trendData = data['trends'] as List<TrendData>;
            final profitData = data['categories'] as List<ProfitData>;
            final productsData = data['products'] as List<ProductData>;

            return SalesAnalysisView(
              productsData: productsData,
              trendData: trendData,
              profitData: profitData,
            );
          } else {
            return const Center(
              child: Text('No se encontraron datos.'),
            );
          }
        },
      ),
    );
  }
}

