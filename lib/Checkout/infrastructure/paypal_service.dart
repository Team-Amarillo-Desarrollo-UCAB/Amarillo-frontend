import 'package:flutter/material.dart';

class PayPalService {
  void simulatePayment({
    required BuildContext context,
  }) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PayPalSimulationView(),
    ));
  }
}

class PayPalSimulationView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simulación de Pago con PayPal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email de PayPal',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor, ingresa un email válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña de PayPal',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu contraseña';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Validando...')),
                    );
                    Future.delayed(Duration(seconds: 2), () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Pago completado')),
                      );
                      Navigator.pop(context);
                    });
                  }
                },
                child: Text('Simular Pago'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}