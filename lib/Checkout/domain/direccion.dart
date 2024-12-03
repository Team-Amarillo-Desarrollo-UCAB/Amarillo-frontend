class Direccion {
  final String nombre;
  final String direccionCompleta;
  bool isSelected;

  Direccion({
    required this.nombre,
    required this.direccionCompleta,
    this.isSelected = false,
  });
}
