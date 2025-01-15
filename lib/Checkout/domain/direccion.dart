class Direccion {
  final String nombre;
  final String direccionCompleta;
  final double latitude;
  final double longitude;
  bool isSelected;

  Direccion({
    required this.nombre,
    required this.direccionCompleta,
    required this.latitude,
    required this.longitude,
    this.isSelected = false,
  });
}
