import 'package:flutter/material.dart';
import 'package:tex_app/Components/card_descuento.dart';
import 'package:tex_app/Models/roll.dart';
import 'package:tex_app/constans.dart';
import 'package:tex_app/sizeconfig.dart';

class MovsScreen extends StatelessWidget {
  const MovsScreen({super.key, required this.roll});
  final Roll roll;
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: 
     Scaffold(
      appBar: AppBar(title: Text('Rollo: ${roll.id}')),
        body:  Container(
        color: kColorAlternativo,
        child: Column( 
        children: [
        const SizedBox(height: 10,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
            child: Center(
              child: Text(
                "Movimientos",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(20),
                  color: kContrateFondoOscuro,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        const Divider(
          height: 40,
          thickness: 2,
          color: kContrastColor,
          ), 
          
          SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: 
            [
              ...List.generate(
              roll.descuentos!.length,
                (index) {      
                    return CardDescuento(descuento: roll.descuentos![index]);          
                },
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
          ),
            const Divider(
          height: 40,
          thickness: 2,
          color: kContrastColor,
          ), 
        ],
      ),
    ),
      )
    );
  }

}