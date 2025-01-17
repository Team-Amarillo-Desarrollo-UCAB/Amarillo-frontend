# ¡Bienvenidos al Frontend de Amarillo GoDely!

Repositorio del Frontend de la aplicación GoDely del equipo Amarillo - aplicación móvil enfocada a la gestión de pedidos, catálogos de productos y combos y demás aspectos derivados.

# Arquitectura

Nuestra aplicación hace uso de patrones de diseño y arquitecturas con el fin de favorecer buenas prácticas en el proceso de desarrollo de software, entre las cuales se destacan diversos aspectos tales como el favorecer la programación en paralelo, reutilización de componentes, mejorar la mantenibilidad, código fácil de testear, entre otros. Particularmente, los detalles con respecto a la arquitectura del software, se resalta:

Arquitectura Hexagonal
También conocida como la Arquitectura de Puertos y Adaptadores (impulsado por el Principio de Inversión de Dependencias - DIP de SOLID), según la describe el Dr. Alistair Cockburn, esta arquitectura se basa en permitir que una aplicación sea controlada por igual por usuarios, programas, pruebas automatizadas, etc. Con ello, se logra separar la lógica de dominio (business enterprise logic), lógica de aplicación o casos de uso y aspectos de infraestructura.

![Arquitectura Front](https://github.com/user-attachments/assets/74d86f80-063a-44f8-b98e-cbf68c565437)

# Instalacion de dependencias
```bash
$ flutter pub get
```

# ¿Como correr el proyecto?
```bash
$ flutter run
```

