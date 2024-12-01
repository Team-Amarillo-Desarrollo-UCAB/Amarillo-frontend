import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_profile_screen.dart';
import 'logout_dialog.dart';
import 'user_profile.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);// Constructor de la clase

  @override
  Widget build(BuildContext context) {
    //final userProfile = Provider.of<UserProfile>(context);
    final userProfile = UserProfile.defaultProfile(); // Perfil por defecto
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'), // Título de la pantalla
        centerTitle: true,// Centrar el título
        automaticallyImplyLeading: false, 
      ), 
      body: Column(
        children: [
          const SizedBox(height: 20), // Espaciado superior
          Center(
            child: Stack(
              children: [
                // Imagen de perfil
                CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('assets/img/perfil.png'), // Imagen por defecto
                ), 
                // Botón para editar la imagen de perfil
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // Acción para subir imagen
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.orangeAccent,
                      child: const Icon(Icons.edit, color: Colors.white),
                    ), // CircleAvatar
                  ), 
                ), 
              ], // Children del Stack
            ), 
          ), 
          const SizedBox(height: 10), // Espaciado
          Text(
            userProfile.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ), // Nombre del usuario
           Text(
            userProfile.phoneNumber,
            style: TextStyle(color: Colors.grey),
          ), // Número del usuario
          const SizedBox(height: 30), // Espaciado
          // Sección de "Editar Perfil"
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person, color: Color(0xFFFF7622)),
                title: const Text('Editar Perfil'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  //Navigator.push(context, MaterialPageRoute(
                                       // builder: (context) => EditProfileScreen()));
                }, // onTap
              ), 
              const Divider(
                thickness: 1,
                color: Color(0xFFFFD4B2), // Barra anaranjada clara
              ), 
            ], // Children de la columna
          ), 
          // Sección de "Notificaciones"
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.notifications, color: Color(0xFFFF7622)),
                title: const Text('Notificaciones'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () { 
                  // Navegación a la pantalla Notificaciones
                }, // onTap
              ), 
              const Divider(
                thickness: 1,
                color: Color(0xFFFFD4B2), // Barra anaranjada clara
              ), 
            ], // Children de la columna
          ), 
          // Sección de "Configuración"
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.settings, color: Color(0xFFFF7622)),
                title: const Text('Configuración'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {  // Navegación a la pantalla Configuración
                }, // onTap
              ), 
              const Divider(
                thickness: 1,
                color: Color(0xFFFFD4B2), // Barra anaranjada clara
              ), 
            ], // Children de la columna
          ), 
          // Botón de "Cerrar Sesión"
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
            onTap: () {
              showLogoutConfirmationDialog(context);
            }, // onTap
          ), 
        ], // Children del Column principal
      ),
    ); 
  } // build
} // UserProfileScreen
