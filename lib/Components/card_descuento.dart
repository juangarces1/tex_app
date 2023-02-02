import 'package:flutter/material.dart';
import 'package:tex_app/Components/text_derecha.dart';
import 'package:tex_app/Components/text_encabezado.dart';
import 'package:tex_app/Models/descuento.dart';
import 'package:tex_app/constans.dart';
import 'package:tex_app/sizeconfig.dart';

class CardDescuento extends StatelessWidget {
  const CardDescuento({super.key, required this.descuento});
  final Descuento descuento;

  @override
  Widget build(BuildContext context) {
     return Padding(
    padding: EdgeInsets.only(left: getProportionateScreenWidth(20), bottom: 5),
    child: 
      Card(
        color:kContrastColor,
          shadowColor: kPrimaryColor,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding
        (
          padding: const EdgeInsets.only(left: 8,  bottom: 5, top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
            Container(
                height: 60,
                width: 60,
                padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                decoration: BoxDecoration(
                color: kSecondaryColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const AspectRatio(
                aspectRatio: 4,
                child: Image(image:  AssetImage('assets/iconNuevo.png'), fit: BoxFit.fill,)),
              ),  
               const SizedBox(width: 10,),        
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Row(
                  children: [
                     const TextEncabezado(texto: 'Fecha: '),
                    TextDerecha(texto: descuento.date!.substring(0,10)),
                  ]),

                     Row(
                  children: [
                       const TextEncabezado(texto: 'Descuento: '),
                  TextDerecha(texto: descuento.descuento.toString()),   
                  ]),

                     Row(
                  children: [
                       const TextEncabezado(texto: 'Vendedor: '),
                  TextDerecha(texto: '${descuento.employee!.firstName.toString()} ${descuento.employee!.lastName.toString()}'),   
                  ]),
             
           
             
                ],
              ),
                    
            ],                  
          ),
        ),
      ),                 
   );
  }
}