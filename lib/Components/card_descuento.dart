import 'package:flutter/material.dart';
import 'package:tex_app/Models/descuento.dart';
import 'package:tex_app/constans.dart';
import 'package:tex_app/sizeconfig.dart';

class CardDescuento extends StatelessWidget {
  const CardDescuento({super.key, required this.descuento});
  final Descuento descuento;

  @override
  Widget build(BuildContext context) {
     return Padding(
    padding: EdgeInsets.only(left: getProportionateScreenWidth(20), bottom: 10),
    child: 
      Card(
        color:kContrastColor,
          shadowColor: kPrimaryColor,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding
        (
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                decoration: BoxDecoration(
                color: kSecondaryColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Image(image:  AssetImage('assets/iconNuevo.png')),
              ),          
            Row(children: [
              Text(
                'Fecha:',
                style:  TextStyle(
                  color: kPrimaryColor,
                  fontSize: getProportionateScreenWidth(18),
                  fontWeight: FontWeight.w600,
                 ),        
                ),
              Text(
                    descuento.date!.substring(0,10),
                    style:  TextStyle(
                      color: kTextColorBlack,
                      fontSize: getProportionateScreenWidth(16),
                          fontWeight: FontWeight.w500,
                    ),                  
                  ),
                ],
              ),
          
            Row(children: [
                  Text(
                    'Descuento: ',
                    style:  TextStyle(
                      color: kPrimaryColor,
                      fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w600,
                    ),
            
                    ),
                  Text(
                        descuento.descuento.toString(),
                        style:  TextStyle(
                          color: kTextColorBlack,
                          fontSize: getProportionateScreenWidth(16),
                              fontWeight: FontWeight.w500,
                        ),
                      
                      ),

                    ],
                ),          
            ],                  
          ),
        ),
      ),                 
   );
  }
}