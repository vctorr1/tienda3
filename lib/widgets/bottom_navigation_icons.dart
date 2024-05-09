import 'package:flutter/material.dart';
import 'custom_text.dart';

class BottomNavIcon extends StatelessWidget {
  final String image; // Parámetro obligatorio
  final String name; // Parámetro obligatorio
  final void Function()? onTap; // Parámetro opcional, puede ser nulo

  const BottomNavIcon({
    Key? key,
    required this.image, // Uso de `required`
    required this.name, // Uso de `required`
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap ?? () {}, // Asigna una función predeterminada si es nulo
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Alineación central
          children: <Widget>[
            Image.asset(
              "images/$image",
              width: 20,
              height: 20, // Tamaño de la imagen
            ),
            const SizedBox(height: 2), // Espacio entre elementos
            CustomText(
              text: name,
              size: 14, // Tamaño del texto
            ),
          ],
        ),
      ),
    );
  }
}
