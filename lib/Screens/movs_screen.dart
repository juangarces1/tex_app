import 'package:flutter/material.dart';
import 'package:tex_app/Components/card_descuento.dart';
import 'package:tex_app/Components/titulos.dart';
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
        backgroundColor: kColorAlternativo,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white,),
        backgroundColor: kPrimaryColor,
        title: TitulosText(color: Colors.white, text:'Rollo: ${roll.id}' 
        , fontSize: 20)),
        body:  Container(
        color: kColorAlternativo,
        child: SingleChildScrollView(
          child: Column( 
          children: [
          const SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
              child: const Center(
                child: TitulosText(color: Colors.white, text: 'Movimientos', fontSize: 20),
              ),
            ),
        
             SizedBox(height: getProportionateScreenWidth(10)),
            Column(
              children: 
              [
                ...List.generate(
                roll.descuentos!.length,
                  (index) {      
                      return Padding(
                        padding:  EdgeInsets.only(left: getProportionateScreenWidth(5), right: getProportionateScreenWidth(20)),
                        child: CardDescuento(descuento: roll.descuentos![index]),
                      );          
                  },
                ),
                SizedBox(width: getProportionateScreenWidth(20)),
              ],
            ),
            
          ],
              ),
        ),
    ),
      )
    );
  }

}