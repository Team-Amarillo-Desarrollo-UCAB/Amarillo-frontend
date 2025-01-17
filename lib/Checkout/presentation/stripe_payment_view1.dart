import 'dart:convert';
import 'package:desarrollo_frontend/common/presentation/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripePaymentView extends StatefulWidget {
  final double amount;
  StripePaymentView({required this.amount, super.key});

  @override
  State<StripePaymentView> createState() => _StripePaymentViewState();
}

class _StripePaymentViewState extends State<StripePaymentView> {
  String PublishableKey =
      "pk_test_51QPCuGRp6TYNTJcRgQQCOypVsFeQdu0xFvFxdKyX8G4UewYVHRmtRLgu9kMpdaBKgZbtG3Q7v1Qlp7NiPzcU1Yvl00RiGsPKJl";
  String SecretKey =
      "sk_test_51QPCuGRp6TYNTJcR4llyNCSMpMVWr7EIHPbVblZt7RQY38176oo9P9hjiVHm2bR31TRJtlwy72s9mnpkd6txxOiu00te3NAVSe";

  Map<String, dynamic>? paymentIntentData;

  String? token;

  showPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((val) {
        paymentIntentData = null;

        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Column(
                    children: const [
                      Icon(Icons.check, size: 50, color: Colors.orangeAccent),
                      SizedBox(height: 10),
                      Text(
                        "¡Pago Efectuado!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  content: Text(
                    "El pago se ha completado con éxito y el ID de pago es ${token}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: TColor.gradient,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.pop(context, token);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          shadowColor: Colors.transparent,
                        ),
                        child: const Text('Continuar',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ));
      }).onError((e, stackTrace) {
        print(e);
      });
    } on StripeException catch (e) {
      print(e.error.localizedMessage);

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Column(
                  children: const [
                    Icon(Icons.error, size: 50, color: Colors.orangeAccent),
                    SizedBox(height: 10),
                    Text(
                      "¡Pago No Realizado!",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                content: Text(
                  "El pago no se ha completado con éxito",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: TColor.gradient,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        Navigator.pop(context, token);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text('Continuar',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ));
    } catch (e) {
      print(e);
    }
  }

  makeIntentForPayment(amountToBeCharge, currency) async {
    try {
      Map<String, dynamic> paymentInfo = {
        "amount": (int.parse(amountToBeCharge) * 100).toString(),
        "currency": currency,
        "payment_method_types[]": "card",
      };

      var responseFromStripe = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: paymentInfo,
          headers: {
            "Authorization": "Bearer $SecretKey",
            "Content-Type": "application/x-www-form-urlencoded"
          });

      var decodedResponse = jsonDecode(responseFromStripe.body);

      token = decodedResponse['id'];

      print(decodedResponse);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment ID: ${decodedResponse['id']}')));
      return decodedResponse;
    } catch (e) {
      print(e);
    }
  }

  paymentSheetInitialization(amountToBeCharge, currency) async {
    try {
      paymentIntentData =
          await makeIntentForPayment(amountToBeCharge, currency);
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        allowsDelayedPaymentMethods: true,
        paymentIntentClientSecret: paymentIntentData!['client_secret'],
        style: ThemeMode.dark,
        merchantDisplayName: 'GoDely',
      ));
      showPaymentSheet();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: const [
            Icon(Icons.check, size: 50, color: Colors.orangeAccent),
            SizedBox(height: 10),
            Text(
              "¿Seguro que desea cancelar en Stripe?",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          "El pago se efectuara por el metodo de pago de: Stripe",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              gradient: TColor.gradient,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ElevatedButton(
              onPressed: () {
                paymentSheetInitialization(
                    widget.amount.round().toString(), "USD");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                shadowColor: Colors.transparent,
              ),
              child: Text(
                  'Pagar con Stripe \$${widget.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white)),
            ),
          ),
        ]);
  }
}
