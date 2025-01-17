// import 'package:googleapis_auth/googleapis_auth.dart';
// import 'package:http/http.dart' as http;

// Future<String> getAccessToken() async {
//   final clientId = ClientId(
//     'TU_CLIENT_ID.apps.googleusercontent.com',
//     'TU_CLIENT_SECRET',
//   );

//   final scopes = ['https://www.googleapis.com/auth/cloud-platform'];

//   final authClient = await clientViaUserConsent(clientId, scopes, (url) {
//     print('Visita esta URL para autenticar: $url');
//   });

//   return authClient.credentials.accessToken.data;
// }
