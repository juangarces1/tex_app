import 'package:flutter/material.dart';
import 'package:tex_app/Components/text_derecha.dart';
import 'package:tex_app/Components/text_encabezado.dart';
import 'package:tex_app/Models/roll.dart';
import 'package:tex_app/Screens/movs_screen.dart';
import 'package:tex_app/constans.dart';
import 'package:tex_app/sizeconfig.dart';


class CardRoll extends StatefulWidget {
  const CardRoll({super.key, required this.roll});
  final Roll roll;
 

  @override
  State<CardRoll> createState() => _CardRollState();
}

class _CardRollState extends State<CardRoll> {
  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: EdgeInsets.only(left: getProportionateScreenWidth(5), bottom: 10),
    child: 
      Card(
        color:kContrastColorMedium,
          shadowColor: kPrimaryColor,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding
        (
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                InkWell(
            onTap: () => goMovs(),
            child: Container(
                height: 65,
                width: 65,
                padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                decoration: BoxDecoration(
                color: kSecondaryColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Image(image:  AssetImage('assets/iconNuevo.png'), fit: BoxFit.fill,),
              )
            ),
          
            Row(children: [
                  const TextEncabezado(texto: 'Rollo # '),
                  TextDerecha(texto: widget.roll.id.toString()),                 
                ],
              ),

               Row(children: [
                  const TextEncabezado(texto: 'Cantidad:  '),
                  TextDerecha(texto: widget.roll.cantidad.toString()),                 
                ],
              ),

               Row(children: [
                  const TextEncabezado(texto: 'Stock: '),
                  TextDerecha(texto: widget.roll.inventario.toString()),                 
                ],
              ),
              
               Row(children: [
                  const TextEncabezado(texto: 'Ubicacion: '),
                  TextDerecha(texto: widget.roll.status.toString()),                 
                ],
              ),
                  
               Row(children: [
                  const TextEncabezado(texto: 'Movimientos: '),
                  TextDerecha(texto: widget.roll.movimienotos.toString()),                 
                ],
              ),
          
         
            
                         
            ],                  
          ),
        ),
      ),                 
   );
  }

   goMovs() {
     Navigator.push(
        context,  
        MaterialPageRoute(
          builder: (context) => MovsScreen(roll: widget.roll,)
      ));  
  }
}