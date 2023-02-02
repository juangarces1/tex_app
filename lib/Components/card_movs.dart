

import 'package:flutter/material.dart';
import 'package:tex_app/Components/text_derecha.dart';
import 'package:tex_app/Components/text_encabezado.dart';
import 'package:tex_app/Models/descuento.dart';
import 'package:tex_app/constans.dart';

class CardMovimiento extends StatelessWidget {
  const CardMovimiento({super.key, required this.descuento});
  final Descuento descuento;
  
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Card(
          color:kContrastColorMedium,
            shadowColor: kPrimaryColor,
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
              leading:  const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/iconNuevo.png'),
              ),
              title: TextEncabezado(texto: 'Cant:${descuento.descuento.toString()} - Fecha: ${descuento.date!.substring(0,10)}'),

                      subtitle: TextDerecha(texto: 'Vendedor: ${descuento.employee!.firstName} ${descuento.employee!.lastName}'),
          ),
          
      ),
    );
  }
}

//Text('Cant:${descuento.descuento.toString()} - Fecha: ${descuento.date!.substring(0,10)}') ,Text('Vendedor: ${descuento.employee!.firstName} ${descuento.employee!.lastName}'),