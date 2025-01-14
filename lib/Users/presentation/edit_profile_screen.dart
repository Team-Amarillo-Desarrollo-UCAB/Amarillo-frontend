import 'package:desarrollo_frontend/Users/infrastructure/user_service_update.dart';
import 'package:flutter/material.dart';
import '../../common/infrastructure/base_url.dart';
import '../../common/presentation/color_extension.dart';
import '../domain/user_profile.dart';
import 'package:provider/provider.dart';


class EditProfileScreen extends StatefulWidget {

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}


  class _EditProfileViewState extends State<EditProfileScreen> {

    late UserProfile userProfile;
    late TextEditingController nameController;
    late TextEditingController phoneNumberController;
    late TextEditingController emailController;
    final UserUpdate userUpdate = UserUpdate(BaseUrl().BASE_URL);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProfile = Provider.of<UserProfile>(context, listen: false);
    nameController = TextEditingController(text: userProfile.name);
    phoneNumberController = TextEditingController(text: userProfile.phoneNumber);
    emailController = TextEditingController(text: userProfile.email);
  }

  Future<void> _editProfile() async {
  try {
    Map<String, dynamic> updatedFields = {};

    if (nameController.text != userProfile.name) {
      updatedFields['name'] = nameController.text.trim();
    }
    if (phoneNumberController.text != userProfile.phoneNumber) {
      updatedFields['phone'] = phoneNumberController.text.trim();
    }
    if (emailController.text != userProfile.email) {
      updatedFields['email'] = emailController.text.trim();
    }
    if (updatedFields.isNotEmpty) {
      final response = await userUpdate.update(updatedFields);
      if (response.isSuccessful) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Se han actualizado los datos correctamente.'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${response.errorMessage}'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No hay cambios para guardar.'),
      ));
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Ocurrió un error, por favor intente nuevamente.'),
    ));
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.secondary,
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
            const SizedBox(height: 16),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(labelText: 'Número de celular'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
              keyboardType: TextInputType.emailAddress,
            ),
             Spacer(),
            ElevatedButton(
              onPressed: () async {
                await _editProfile();
                userProfile.updateProfile(
                  nameController.text,
                  phoneNumberController.text,
                  emailController.text,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primary,
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
