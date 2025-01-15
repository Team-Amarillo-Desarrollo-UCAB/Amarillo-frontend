import 'package:desarrollo_frontend/statistics/domain/product_data.dart';
import 'package:flutter/material.dart';
import '../../../common/presentation/color_extension.dart';
import '../../domain/profit_data.dart';
import '../../domain/trend_data.dart';
import 'sales_analysis_view.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Aquí pasas los datos de ejemplo o dinámicos
    final productsData = [
      ProductData(name: "Queso Crema", quantity: 500),
      ProductData(name: "Cheese", quantity: 500),
      ProductData(name: "Cheese", quantity: 500),
      ProductData(name: "Cheese", quantity: 500),
      ProductData(name: "Cheese", quantity: 500),
      ProductData(name: "Cheese", quantity: 500),
      ProductData(name: "Queso Crema", quantity: 500),
      ProductData(name: "Cheese", quantity: 500),
      ProductData(name: "Cheese", quantity: 500),     
      
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
      ProfitData(name: 'Alcohol', value: 110, color: Colors.indigo[900]!),
      ProfitData(name: 'Jazmin', value: 106, color: Colors.blueGrey),
      ProfitData(name: 'Pomelo', value: 92, color: Colors.grey[600]!),
      ProfitData(name: 'Limón', value: 72, color: Colors.lime[300]!),
      ProfitData(name: 'Naranja', value: 60, color: Colors.orange[200]!),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.secondary,
          centerTitle: true,
          title: const Text('Estadísticas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => const ComboView()));
              }),
      ),
      body: SalesAnalysisView(
        productsData: productsData,
        trendData: trendData,
        profitData: profitData,
      ),
    );
  }
}
