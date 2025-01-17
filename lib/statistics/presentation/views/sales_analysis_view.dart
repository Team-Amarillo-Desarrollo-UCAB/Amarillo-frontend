import 'dart:math';

import 'package:desarrollo_frontend/common/presentation/color_extension.dart';
import 'package:desarrollo_frontend/statistics/domain/product_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../domain/profit_data.dart';
import '../../domain/trend_data.dart';

class NetProfitChart extends StatelessWidget {
  final List<ProfitData> data;

  const NetProfitChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: data.map((item) {
                  return PieChartSectionData(
                    value: item.value,
                    title: '${item.value}',
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    color: item.color,
                    radius: 100,
                    showTitle: true,
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: item.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SalesAnalysisView extends StatelessWidget {
  final List<ProductData> productsData;
  final List<TrendData> trendData;
  final List<ProfitData> profitData;

  const SalesAnalysisView({
    Key? key,
    required this.productsData,
    required this.trendData,
    required this.profitData,
  }) : super(key: key);

List<ProfitData> generateProfitDataWithColors(List<ProfitData> originalData) {
  final random = Random();
  return originalData.map((data) {
    return ProfitData(
      name: data.name,
      value: data.value,
      color: Color.fromARGB(
        255,
        random.nextInt(256), // Valor aleatorio para el canal rojo
        random.nextInt(256), // Valor aleatorio para el canal verde
        random.nextInt(256), // Valor aleatorio para el canal azul
      ),
    );
  }).toList();
}

  @override
  Widget build(BuildContext context) {
    final profitDataWithColors = generateProfitDataWithColors(profitData);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildAccumulatedProfitCard(),
                    const SizedBox(height: 16),
                    _buildTrendAnalysisCard(),
                    const SizedBox(height: 16),
                    _buildNetProfitCard(profitDataWithColors),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTabButton(String text, bool isSelected) {
    return TextButton(
      onPressed: () {},
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }

Widget _buildAccumulatedProfitCard() {
  return _buildCard(
    'Compras realizadas por producto',
    SizedBox(
      height: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: productsData.length * 80.0, // Aumenta el ancho para evitar superposición
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceBetween, // Ajusta el espaciado entre grupos
              maxY: 600,
              barTouchData: BarTouchData(enabled: true),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      // Obtiene el índice actual y valida que esté dentro del rango
                      int index = value.toInt();
                      if (index >= 0 && index < productsData.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            productsData[index].name, 
                            style: const TextStyle(fontSize: 10),
                            overflow: TextOverflow.ellipsis, 
                          ),
                        );
                      }
                      return const SizedBox(); // Retorna un widget vacío si el índice es inválido
                    },
                  ),
                ),
              ),
              barGroups: productsData.asMap().entries.map((entry) {
                final data = entry.value;
                return BarChartGroupData(
                  x: entry.key,
                  barsSpace: 8, // Espaciado entre barras dentro del grupo
                  barRods: [
                    BarChartRodData(
                      toY: data.quantity,
                      width: 16,
                      color: TColor.primary,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    ),
  );
}



  Widget _buildTrendAnalysisCard() {
    return _buildCard(
      'Tendencia de compras mensuales',
      SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: trendData.map((data) {
                  return FlSpot(data.x, data.actual);
                }).toList(),
                isCurved: true,
                color: TColor.secondary,
                dotData: FlDotData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildNetProfitCard(profitDataWithColors) {
  return _buildCard(
    'Categorías más compradas',
    NetProfitChart(data: profitData),
  );
}

  Widget _buildCard(String title, Widget child) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
