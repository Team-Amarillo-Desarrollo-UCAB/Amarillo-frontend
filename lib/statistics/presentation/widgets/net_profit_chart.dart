import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/profit_data.dart';

class NetProfitChart extends StatelessWidget {
  final List<ProfitData> data;

  const NetProfitChart({Key? key, required this.data}) : super(key: key);

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
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.map((item) {
                return Row(
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
                    Text(item.name, style: const TextStyle(fontSize: 12)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
