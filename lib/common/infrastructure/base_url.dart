
class BaseUrl {
  //final BASE_URL = 'http://10.0.2.2:3000';
  static final BaseUrl _instance = BaseUrl._internal();

  String BASE_URL = '';
  final String AMARILLO = 'https://amarillo-backend-production.up.railway.app';
  final String ORANGE = 'https://orangeteam-deliverybackend-production.up.railway.app/api#/ ';
  final String VERDE = 'https://godelybackverde.up.railway.app/docs#/ ';

  factory BaseUrl() {
    return _instance;
  }

  BaseUrl._internal();
}
