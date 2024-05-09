import 'package:flutter/material.dart';
import 'package:tienda3/paginas/helpers/style.dart';

class CustomText extends StatelessWidget {
  final String text; // Argumento obligatorio
  final double? size; // Argumentos opcionales
  final Color? color;
  final FontWeight? weight;

  // Constructor con parámetros obligatorios y opcionales
  const CustomText({
    required this.text, // Uso de `required` en lugar de `@required`
    this.size,
    this.color,
    this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text, // Texto a mostrar
      style: TextStyle(
        fontSize: size ?? 16, // Valor predeterminado
        color: color ?? black, // Valor predeterminado
        fontWeight: weight ?? FontWeight.normal, // Valor predeterminado
      ),
    );
  }
}
