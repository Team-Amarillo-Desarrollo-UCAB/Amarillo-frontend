import 'dart:convert';
import 'package:desarrollo_frontend/Cupon/domain/Cupon.dart';
import 'package:desarrollo_frontend/Cupon/infrastructure/cupon_service_search_by_code.dart';
import 'package:desarrollo_frontend/common/infrastructure/base_url.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/presentation/color_extension.dart';

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
            used: json['used'],
            use: json['use'])));
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
              'used': cupon.used,
              'use': cupon.use
            })
        .toList());
    await prefs.setString('cupones', cuponesString);
  }

  Future<void> _deleteAllCupones() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _cupones.clear();
    });
    await prefs.remove('cupones');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todos los cupones han sido eliminados'),
      ),
    );
  }

  Future<void> _addCupon() async {
    final cuponCode = _cuponController.text.trim();
    if (cuponCode.isNotEmpty) {
      final existingCupon =
          _cupones.firstWhere((cupon) => cupon.code == cuponCode,
              orElse: () => Cupon(
                    code: 'NOT_FOUND',
                    expirationDate: DateTime.now(),
                    amount: '0',
                    used: true,
                    use: 3,
                  ));
      if (existingCupon.code != 'NOT_FOUND') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El cupón ya está en la lista'),
          ),
        );
      } else {
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
                content:
                    Text('Cupón agregado: ${cupon.code} - ${cupon.amount}'),
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
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa un código de cupón válido'),
        ),
      );
    }
  }

  Future<void> _selectCupon(Cupon cupon) async {
    if (cupon.use > 0) {
      setState(() {
        cupon.use -= 1;
        if (cupon.use == 0) {
          cupon.used = true;
        }
      });
      await _saveCupones();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cupón utilizado. Usos restantes: ${cupon.use}'),
        ),
      );
      Navigator.pop(context, cupon);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El cupón ya no se puede usar.'),
        ),
      );
    }
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
            ElevatedButton(
              onPressed: _deleteAllCupones,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Eliminar Todos',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
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
                    onTap: () {
                      if (!cupon.used) {
                        _selectCupon(cupon);
                      }
                    },
                    child: Card(
                      color: cupon.used ? Colors.grey : TColor.primary,
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
                                  'El código es: ${cupon.code}',
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
                            Text(
                              'Usos restantes: ${cupon.use}',
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
                  backgroundColor: TColor.primary,
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
