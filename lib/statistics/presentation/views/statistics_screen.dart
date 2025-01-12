import 'package:desarrollo_frontend/statistics/domain/product_data.dart';
import 'package:flutter/material.dart';
import '../../domain/profit_data.dart';
import '../../domain/trend_data.dart';
import 'sales_analysis_view.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Aquí pasas los datos de ejemplo o dinámicos
    final productsData = [
      ProductData(thisYear: 200, target: 500, lastYear: 100),
      ProductData(thisYear: 300, target: 250, lastYear: 200),
      ProductData(thisYear: 400, target: 300, lastYear: 300),
    ];

    final trendData = List.generate(
      6,
      (index) => TrendData(
        x: index.toDouble(),
        actual: 400 + 200 * index.toDouble(),
        target: 300 + 250 * index.toDouble(),
      ),
    );

    final profitData = [
      ProfitData(name: 'Rosa', value: 169, color: Colors.pink[100]!),
      ProfitData(name: 'Lavanda', value: 143, color: Colors.purple[200]!),
      ProfitData(name: 'Benzil Benzoato', value: 124, color: Colors.blue[300]!),
      ProfitData(name: 'Almizole', value: 118, color: Colors.teal[300]!),
      ProfitData(name: 'Sandalo', value: 116, color: Colors.green[400]!),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
        centerTitle: true,
      ),
      body: SalesAnalysisView(
        productsData: productsData,
        trendData: trendData,
        profitData: profitData,
      ),
    );
  }
}
