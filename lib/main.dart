import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Users/domain/user_profile.dart';
import 'api/firebase_api.dart';
import 'common/presentation/startup_view.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  final userProfile = await UserProfile.loadFromPreferences();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => userProfile),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoDely',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Metropolis",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainTabView()//StartupView(),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class NetProfitChart extends StatelessWidget {
//   final List<ProfitData> data;

//   const NetProfitChart({
//     Key? key,
//     required this.data,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 300,
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: PieChart(
//               PieChartData(
//                 sectionsSpace: 2,
//                 centerSpaceRadius: 40,
//                 sections: data.map((item) {
//                   return PieChartSectionData(
//                     value: item.value,
//                     title: '${item.value}',
//                     titleStyle: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                     color: item.color,
//                     radius: 100,
//                     showTitle: true,
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Padding(
//               padding: const EdgeInsets.only(left: 16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: data.map((item) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 4.0),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 12,
//                           height: 12,
//                           decoration: BoxDecoration(
//                             color: item.color,
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             item.name,
//                             style: const TextStyle(
//                               fontSize: 12,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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

// Widget _buildNetProfitCard() {
//   return _buildCard(
//     'Net Profit for This Month',
//     NetProfitChart(data: profitData),
//   );
// }

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
//   final String name;
//   final double value;
//   final Color color;

//   ProfitData({
//     required this.name,
//     required this.value,
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
//             (index) => TrendData(
//           x: index.toDouble(),
//           actual: 400 + 200 * index.toDouble(),
//           target: 300 + 250 * index.toDouble(),
//         ),
//       ),
//       profitData: [
//   ProfitData(name: 'Rosa', value: 169, color: Colors.pink[100]!),
//   ProfitData(name: 'Lavanda', value: 143, color: Colors.purple[200]!),
//   ProfitData(name: 'Benzil Benzoato', value: 124, color: Colors.blue[300]!),
//   ProfitData(name: 'Almizole', value: 118, color: Colors.teal[300]!),
//   ProfitData(name: 'Sandalo', value: 116, color: Colors.green[400]!),
//   ProfitData(name: 'Alcohol', value: 110, color: Colors.indigo[900]!),
//   ProfitData(name: 'Jazmin', value: 106, color: Colors.blueGrey),
//   ProfitData(name: 'Pomelo', value: 92, color: Colors.grey[600]!),
//   ProfitData(name: 'Limón', value: 72, color: Colors.lime[300]!),
//   ProfitData(name: 'Naranja', value: 60, color: Colors.orange[200]!),
// ],
//     ),
//   ));
// }
