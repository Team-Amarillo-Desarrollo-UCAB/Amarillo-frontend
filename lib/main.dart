import 'package:desarrollo_frontend/login/presentation/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'Producto/presentation/product_individual_view.dart';
import 'Users/domain/user_profile.dart';
import 'api/firebase_api.dart';
import 'chatbot/prueba.dart';
import 'chatbot/prueba2.dart';
import 'common/presentation/startup_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'common/presentation/main_tabview.dart';
import 'statistics/presentation/views/statistics_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51QPCuGRp6TYNTJcRgQQCOypVsFeQdu0xFvFxdKyX8G4UewYVHRmtRLgu9kMpdaBKgZbtG3Q7v1Qlp7NiPzcU1Yvl00RiGsPKJl';
  await Stripe.instance.applySettings();
  await Firebase.initializeApp();
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
      home: const StartupView(), 
      //home: const PerfumeDetailPage(),
      // home: ChatBotScreen(),
      //home: HomeScreen(),
      //  home: StatisticsScreen(),
    );
  }
}
