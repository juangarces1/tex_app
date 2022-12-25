

import 'package:flutter/material.dart';
import 'package:tex_app/Models/descuento.dart';
import 'package:tex_app/constans.dart';

class CardMovimiento extends StatelessWidget {
  const CardMovimiento({super.key, required this.descuento});
  final Descuento descuento;
  
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Card(
          color:kContrastColor,
            shadowColor: kPrimaryColor,
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
              leading: const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/iconNuevo.png'),
              ),
              title: Text(descuento.descuento.toString()),
              subtitle: Text(descuento.date!.substring(0,10)),
          ),
          
      ),
    );
  }
}