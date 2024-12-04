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
            const SizedBox(height: 20),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(labelText: 'Número de celular'),
              keyboardType: TextInputType.phone,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                userProfile.updateProfile(
                  nameController.text,
                  phoneNumberController.text
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              child: const Text('Guardar datos', style: TextStyle(fontSize: 18, color: Colors.white)),

            ),
          ],
        ),
      ),
    );
  }
}
