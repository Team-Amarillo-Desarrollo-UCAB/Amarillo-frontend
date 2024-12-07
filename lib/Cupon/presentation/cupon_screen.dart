import 'dart:convert';

import 'package:desarrollo_frontend/Cupon/domain/Cupon.dart';
import 'package:desarrollo_frontend/Cupon/infrastructure/cupon_service_search_by_code.dart';
import 'package:desarrollo_frontend/common/infrastructure/base_url.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CuponView extends StatefulWidget {
  @override
  _CuponViewState createState() => _CuponViewState();
}

class _CuponViewState extends State<CuponView> {
  final TextEditingController _cuponController = TextEditingController();
  final CuponServiceSearchByCode _cuponService =
      CuponServiceSearchByCode(BaseUrl().BASE_URL);
  final List<Cupon> _cupones = [];
  @override
  void initState() {
    super.initState();
    _loadCupones();
  }

  Future<void> _loadCupones() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cuponesString = prefs.getString('cupones');
    if (cuponesString != null) {
      final List<dynamic> cuponesJson = json.decode(cuponesString);
      setState(() {
        _cupones.clear();
        _cupones.addAll(cuponesJson.map((json) => Cupon(
              code: json['code'],
              expirationDate: DateTime.parse(json['expirationDate']),
              amount: json['amount'],
            )));
      });
    }
  }

  Future<void> _saveCupones() async {
    final prefs = await SharedPreferences.getInstance();
    final String cuponesString = json.encode(_cupones
        .map((cupon) => {
              'code': cupon.code,
              'expirationDate': cupon.expirationDate.toIso8601String(),
              'amount': cupon.amount,
            })
        .toList());
    await prefs.setString('cupones', cuponesString);
  }

  Future<void> _addCupon() async {
    final cuponCode = _cuponController.text.trim();
    if (cuponCode.isNotEmpty) {
      try {
        final cupon = await _cuponService.getCuponByCode(cuponCode);
        if (cupon.code == 'ERROR01') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Por favor, ingresa un código de cupón válido'),
            ),
          );
        } else {
          setState(() {
            _cupones.add(cupon);
          });
          await _saveCupones();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cupón agregado: ${cupon.code} - ${cupon.amount}'),
            ),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al agregar el cupón: $error'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa un código de cupón válido'),
        ),
      );
    }
  }

  Future<void> _removeCupon(int index) async {
    setState(() {
      _cupones.removeAt(index);
    });
    await _saveCupones();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cupón eliminado'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cupones'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Quieres agregar un nuevo cupon?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cuponController,
              decoration: InputDecoration(
                hintText: 'Ingresa el código del cupon',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const Divider(),
            const Center(
              child: Text(
                'Lista de Cupones Disponibles',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _cupones.length,
                itemBuilder: (context, index) {
                  final cupon = _cupones[index];
                  return GestureDetector(
                    onTap: () => _removeCupon(index),
                    child: Card(
                      color: Colors.orange,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'El codigo es: ${cupon.code}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  cupon.expirationDate
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${cupon.amount} %',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addCupon,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[400],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Agregar cupon',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
