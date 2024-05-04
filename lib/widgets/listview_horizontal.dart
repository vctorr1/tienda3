import 'package:flutter/material.dart';

//Lista horizontal de categorias
class ListaHorizontal extends StatelessWidget {
  const ListaHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          //Widgets de cada categoria
          Categoria(
              rutaImagen: 'imagenes/categorias/shirt.png', textoImagen: 'Ropa'),
          Categoria(
              rutaImagen: 'imagenes/categorias/diamond.png',
              textoImagen: 'Joyería'),
          Categoria(
              rutaImagen: 'imagenes/categorias/photo.png',
              textoImagen: 'Prints'),
          Categoria(
              rutaImagen: 'imagenes/categorias/brush.png',
              textoImagen: 'Servicios'),
        ],
      ),
    );
  }
}

//Clase para las categorias
class Categoria extends StatelessWidget {
  final String rutaImagen;
  final String textoImagen;

  //Constructor con las variables (hay que usar required delante de los argumentos que le paso)
  const Categoria(
      {super.key, required this.rutaImagen, required this.textoImagen});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: 100,
          child: ListTile(
            title: Image.asset(
              rutaImagen,
              width: 100,
            ),
            subtitle: Container(
              alignment: Alignment.topCenter,
              child: Text(textoImagen),
            ),
          ),
        ),
      ),
    );
  }
}
