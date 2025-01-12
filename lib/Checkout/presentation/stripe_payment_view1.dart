import 'dart:convert';

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

  String PublishableKey = "pk_test_51QgU4kD0dQ04HPD76rBHs2NHCCCkZzPNjbqimYXpqL7arJKeCEKokc4VYWsvyCXYVvQ1jQQl3KWXDURZNLlFPhLY00aIKtvDcv";
  String SecretKey = "sk_test_51QgU4kD0dQ04HPD7mkhJGSNZJUI8t8lnfumsBpmeSI6AInu6FMEmAN2KDKf1ABdpGqpnpq1pqz556XYNQ3OODkna00TIVoNNZr";

  Map<String, dynamic>? paymentIntentData;

  showPaymentSheet() async{
    try{

      await Stripe.instance.presentPaymentSheet().then((val){
        paymentIntentData = null; 
      }).onError((e, stackTrace){
        print(e);
      });

    }
    on StripeException catch(e){
      print(e.error.localizedMessage);

      showDialog(context: context,
       builder: (context) => AlertDialog(
         content: Text("Cancelado"),
         actions: [
           TextButton(
             onPressed: (){
               Navigator.pop(context);
             },
             child: Text("OK"),
           )
         ],
        )
       );
    }
    catch(e){
      print(e);
    }
  }

  makeIntentForPayment(amountToBeCharge,currency) async {
    try{
      Map<String, dynamic> paymentInfo = {
        "amount": (int.parse(amountToBeCharge)*100).toString(),
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

      return jsonDecode(responseFromStripe.body);

    }catch(e){
      print(e);
    }

  }

  paymentSheetInitialization(amountToBeCharge,currency) async{
    try{
       paymentIntentData = await makeIntentForPayment(amountToBeCharge,currency);
       await Stripe.instance.initPaymentSheet(
        paymentSheetParameters : SetupPaymentSheetParameters(
          allowsDelayedPaymentMethods: true,
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'GoDely',
        )
       );
       showPaymentSheet();
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pago con Stripe"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(onPressed: (){

              paymentSheetInitialization(
                widget.amount.round().toString(),
                "USD"
              );

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)
              )
            ),
            child: Text(
              'Pagar con Stripe \$${widget.amount.toStringAsFixed(2)}', style: TextStyle(color: Colors.white),
              )
            )

          ],
        ),
      ),
    );
  }
}