// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class SalesAnalysisView extends StatelessWidget {
//   final List<ProductData> productsData;
//   final List<TrendData> trendData;
//   final List<ProfitData> profitData;

//   const SalesAnalysisView({
//     Key? key,
//     required this.productsData,
//     required this.trendData,
//     required this.profitData,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(),
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     _buildAccumulatedProfitCard(),
//                     const SizedBox(height: 16),
//                     _buildTrendAnalysisCard(),
//                     const SizedBox(height: 16),
//                     _buildNetProfitCard(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Column(
//       children: [
//         Row(
//           children: [
//             IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: () {},
//             ),
//             const Text(
//               'Sales Analysis',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildTabButton('Overview', true),
//             _buildTabButton('Market', false),
//             _buildTabButton('Mall', false),
//             _buildTabButton('Store', false),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildTabButton(String text, bool isSelected) {
//     return TextButton(
//       onPressed: () {},
//       child: Text(
//         text,
//         style: TextStyle(
//           color: isSelected ? Colors.blue : Colors.grey,
//           fontSize: 16,
//         ),
//       ),
//     );
//   }

//   Widget _buildAccumulatedProfitCard() {
//     return _buildCard(
//       'Contrast of Accumulated Profit',
//       SizedBox(
//         height: 200,
//         child: BarChart(
//           BarChartData(
//             alignment: BarChartAlignment.spaceAround,
//             maxY: 600,
//             barTouchData: BarTouchData(enabled: true),
//             titlesData: FlTitlesData(
//               show: true,
//               bottomTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   getTitlesWidget: (value, meta) {
//                     return Text('Product ${value.toInt() + 1}');
//                   },
//                 ),
//               ),
//             ),
//             barGroups: productsData.asMap().entries.map((entry) {
//               final data = entry.value;
//               return BarChartGroupData(
//                 x: entry.key,
//                 barRods: [
//                   BarChartRodData(
//                     toY: data.thisYear,
//                     color: Colors.blue[200],
//                   ),
//                   BarChartRodData(
//                     toY: data.target,
//                     color: Colors.blue,
//                   ),
//                   BarChartRodData(
//                     toY: data.lastYear,
//                     color: Colors.cyan,
//                   ),
//                 ],
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTrendAnalysisCard() {
//     return _buildCard(
//       'Trend Analysis',
//       SizedBox(
//         height: 200,
//         child: LineChart(
//           LineChartData(
//             lineBarsData: [
//               LineChartBarData(
//                 spots: trendData.map((data) {
//                   return FlSpot(data.x, data.actual);
//                 }).toList(),
//                 isCurved: true,
//                 color: Colors.blue,
//                 dotData: FlDotData(show: true),
//               ),
//               LineChartBarData(
//                 spots: trendData.map((data) {
//                   return FlSpot(data.x, data.target);
//                 }).toList(),
//                 isCurved: true,
//                 color: Colors.cyan,
//                 dotData: FlDotData(show: true),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNetProfitCard() {
//     return _buildCard(
//       'Net Profit for This Month',
//       SizedBox(
//         height: 200,
//         child: PieChart(
//           PieChartData(
//             sections: profitData.map((data) {
//               return PieChartSectionData(
//                 value: data.percentage,
//                 color: data.color,
//                 title: '${data.percentage.toStringAsFixed(1)}%',
//                 radius: 60,
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCard(String title, Widget child) {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const Icon(Icons.arrow_forward, size: 20),
//               ],
//             ),
//             const SizedBox(height: 16),
//             child,
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Data models
// class ProductData {
//   final double thisYear;
//   final double target;
//   final double lastYear;

//   ProductData({
//     required this.thisYear,
//     required this.target,
//     required this.lastYear,
//   });
// }

// class TrendData {
//   final double x;
//   final double actual;
//   final double target;

//   TrendData({
//     required this.x,
//     required this.actual,
//     required this.target,
//   });
// }

// class ProfitData {
//   final double percentage;
//   final Color color;

//   ProfitData({
//     required this.percentage,
//     required this.color,
//   });
// }

// // Example usage:
// void main() {
//   runApp(MaterialApp(
//     home: SalesAnalysisView(
//       productsData: [
//         ProductData(thisYear: 200, target: 500, lastYear: 100),
//         ProductData(thisYear: 300, target: 250, lastYear: 200),
//         ProductData(thisYear: 400, target: 300, lastYear: 300),
//       ],
//       trendData: List.generate(
//         6,
//         (index) => TrendData(
//           x: index.toDouble(),
//           actual: 400 + 200 * index.toDouble(),
//           target: 300 + 250 * index.toDouble(),
//         ),
//       ),
//       profitData: [
//         ProfitData(percentage: 41.49, color: Colors.blue),
//         ProfitData(percentage: 34.98, color: Colors.pink),
//         ProfitData(percentage: 23.47, color: Colors.cyan),
//       ],
//     ),
//   ));
// }