import 'package:flutter/material.dart';
import '../domain/user_profile.dart';
import 'package:provider/provider.dart';


class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context, listen: false);

    final nameController = TextEditingController(text: userProfile.name);
    final phoneNumberController = TextEditingController(text: userProfile.phoneNumber);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar perfil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre (s)'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(labelText: 'Número de celular'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Actualizar datos en el modelo
                userProfile.updateProfile(
                  nameController.text,
                  phoneNumberController.text
                );
                // Regresar a la vista de perfil
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              child: const Text('Guardar datos'),
            ),
          ],
        ),
      ),
    );
  }
}
